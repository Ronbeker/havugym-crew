'use server';

import { revalidatePath } from 'next/cache';
import { createSupabaseServerClient } from '@/lib/supabase/server';
import { equipSchema, purchaseSchema } from '@/lib/validation/schemas';
import { actionError, actionOk, friendlyDbError, type ActionResult } from './result';

/**
 * Buys a cosmetic item.
 *
 * The price is never sent from the client. purchase_shop_item() reads it from
 * shop_items, debits through apply_creatine — which refuses to go negative — and
 * grants the item, all in one transaction. A double-clicked button collides with
 * the inventory primary key and the ledger's unique ref index, so the second
 * click cannot buy the same thing twice.
 */
export async function purchaseAction(itemId: number): Promise<ActionResult> {
  const parsed = purchaseSchema.safeParse({ itemId });
  if (!parsed.success) return actionError('That item does not exist.');

  const supabase = await createSupabaseServerClient();
  const { error } = await supabase.rpc('purchase_shop_item', { p_item_id: parsed.data.itemId });
  if (error) return actionError(friendlyDbError(error.message));

  revalidatePath('/shop');
  revalidatePath('/me');
  return actionOk(undefined);
}

export async function equipAction(itemId: number): Promise<ActionResult> {
  const parsed = equipSchema.safeParse({ itemId });
  if (!parsed.success) return actionError('That item does not exist.');

  const supabase = await createSupabaseServerClient();
  const { error } = await supabase.rpc('equip_item', { p_item_id: parsed.data.itemId });
  if (error) return actionError(friendlyDbError(error.message));

  revalidatePath('/shop');
  revalidatePath('/me');
  return actionOk(undefined);
}
