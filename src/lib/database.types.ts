export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  public: {
    Tables: {
      arrivals: {
        Row: {
          announced_at: string
          closed_at: string | null
          expires_at: string
          havura_id: string
          id: string
          note: string | null
          status: Database["public"]["Enums"]["arrival_status"]
          user_id: string
          workout_id: string | null
        }
        Insert: {
          announced_at?: string
          closed_at?: string | null
          expires_at: string
          havura_id: string
          id?: string
          note?: string | null
          status?: Database["public"]["Enums"]["arrival_status"]
          user_id: string
          workout_id?: string | null
        }
        Update: {
          announced_at?: string
          closed_at?: string | null
          expires_at?: string
          havura_id?: string
          id?: string
          note?: string | null
          status?: Database["public"]["Enums"]["arrival_status"]
          user_id?: string
          workout_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "arrivals_havura_id_fkey"
            columns: ["havura_id"]
            isOneToOne: false
            referencedRelation: "havuras"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "arrivals_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "arrivals_workout_id_fkey"
            columns: ["workout_id"]
            isOneToOne: false
            referencedRelation: "workout_feed"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "arrivals_workout_id_fkey"
            columns: ["workout_id"]
            isOneToOne: false
            referencedRelation: "workouts"
            referencedColumns: ["id"]
          },
        ]
      }
      challenge_progress: {
        Row: {
          challenge_id: string
          completed_at: string | null
          paid_at: string | null
          user_id: string
          value: number
        }
        Insert: {
          challenge_id: string
          completed_at?: string | null
          paid_at?: string | null
          user_id: string
          value?: number
        }
        Update: {
          challenge_id?: string
          completed_at?: string | null
          paid_at?: string | null
          user_id?: string
          value?: number
        }
        Relationships: [
          {
            foreignKeyName: "challenge_progress_challenge_id_fkey"
            columns: ["challenge_id"]
            isOneToOne: false
            referencedRelation: "challenges"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "challenge_progress_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      challenges: {
        Row: {
          created_at: string
          havura_id: string
          id: string
          kind: Database["public"]["Enums"]["challenge_kind"]
          reward_creatine: number
          target: number
          week_start: string
        }
        Insert: {
          created_at?: string
          havura_id: string
          id?: string
          kind: Database["public"]["Enums"]["challenge_kind"]
          reward_creatine: number
          target: number
          week_start: string
        }
        Update: {
          created_at?: string
          havura_id?: string
          id?: string
          kind?: Database["public"]["Enums"]["challenge_kind"]
          reward_creatine?: number
          target?: number
          week_start?: string
        }
        Relationships: [
          {
            foreignKeyName: "challenges_havura_id_fkey"
            columns: ["havura_id"]
            isOneToOne: false
            referencedRelation: "havuras"
            referencedColumns: ["id"]
          },
        ]
      }
      competition_results: {
        Row: {
          competition_id: string
          payout: number
          rank: number
          user_id: string
          value: number
        }
        Insert: {
          competition_id: string
          payout?: number
          rank: number
          user_id: string
          value: number
        }
        Update: {
          competition_id?: string
          payout?: number
          rank?: number
          user_id?: string
          value?: number
        }
        Relationships: [
          {
            foreignKeyName: "competition_results_competition_id_fkey"
            columns: ["competition_id"]
            isOneToOne: false
            referencedRelation: "competitions"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "competition_results_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      competitions: {
        Row: {
          havura_id: string
          id: string
          metric: Database["public"]["Enums"]["competition_metric"]
          pot_creatine: number
          settled_at: string | null
          status: Database["public"]["Enums"]["competition_status"]
          week_start: string
        }
        Insert: {
          havura_id: string
          id?: string
          metric: Database["public"]["Enums"]["competition_metric"]
          pot_creatine: number
          settled_at?: string | null
          status?: Database["public"]["Enums"]["competition_status"]
          week_start: string
        }
        Update: {
          havura_id?: string
          id?: string
          metric?: Database["public"]["Enums"]["competition_metric"]
          pot_creatine?: number
          settled_at?: string | null
          status?: Database["public"]["Enums"]["competition_status"]
          week_start?: string
        }
        Relationships: [
          {
            foreignKeyName: "competitions_havura_id_fkey"
            columns: ["havura_id"]
            isOneToOne: false
            referencedRelation: "havuras"
            referencedColumns: ["id"]
          },
        ]
      }
      creatine_ledger: {
        Row: {
          balance_after: number
          created_at: string
          delta: number
          id: string
          reason: Database["public"]["Enums"]["ledger_reason"]
          ref_id: string | null
          ref_type: string | null
          user_id: string
        }
        Insert: {
          balance_after: number
          created_at?: string
          delta: number
          id?: string
          reason: Database["public"]["Enums"]["ledger_reason"]
          ref_id?: string | null
          ref_type?: string | null
          user_id: string
        }
        Update: {
          balance_after?: number
          created_at?: string
          delta?: number
          id?: string
          reason?: Database["public"]["Enums"]["ledger_reason"]
          ref_id?: string | null
          ref_type?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "creatine_ledger_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      exercises: {
        Row: {
          default_rest_seconds: number
          equipment: Database["public"]["Enums"]["equipment_type"]
          id: number
          instructions: string
          is_unilateral: boolean
          movement_pattern:
            | Database["public"]["Enums"]["movement_pattern"]
            | null
          muscle_primary: Database["public"]["Enums"]["muscle_group"]
          muscle_secondary: Database["public"]["Enums"]["muscle_group"][]
          name: string
          slug: string
        }
        Insert: {
          default_rest_seconds: number
          equipment: Database["public"]["Enums"]["equipment_type"]
          id?: never
          instructions: string
          is_unilateral?: boolean
          movement_pattern?:
            | Database["public"]["Enums"]["movement_pattern"]
            | null
          muscle_primary: Database["public"]["Enums"]["muscle_group"]
          muscle_secondary?: Database["public"]["Enums"]["muscle_group"][]
          name: string
          slug: string
        }
        Update: {
          default_rest_seconds?: number
          equipment?: Database["public"]["Enums"]["equipment_type"]
          id?: never
          instructions?: string
          is_unilateral?: boolean
          movement_pattern?:
            | Database["public"]["Enums"]["movement_pattern"]
            | null
          muscle_primary?: Database["public"]["Enums"]["muscle_group"]
          muscle_secondary?: Database["public"]["Enums"]["muscle_group"][]
          name?: string
          slug?: string
        }
        Relationships: []
      }
      havura_members: {
        Row: {
          havura_id: string
          joined_at: string
          role: Database["public"]["Enums"]["havura_role"]
          user_id: string
        }
        Insert: {
          havura_id: string
          joined_at?: string
          role?: Database["public"]["Enums"]["havura_role"]
          user_id: string
        }
        Update: {
          havura_id?: string
          joined_at?: string
          role?: Database["public"]["Enums"]["havura_role"]
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "havura_members_havura_id_fkey"
            columns: ["havura_id"]
            isOneToOne: false
            referencedRelation: "havuras"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "havura_members_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      havuras: {
        Row: {
          created_at: string
          created_by: string | null
          id: string
          invite_code: string
          name: string
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          id?: string
          invite_code: string
          name: string
        }
        Update: {
          created_at?: string
          created_by?: string | null
          id?: string
          invite_code?: string
          name?: string
        }
        Relationships: [
          {
            foreignKeyName: "havuras_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      inventory: {
        Row: {
          acquired_at: string
          equipped: boolean
          item_id: number
          item_kind: Database["public"]["Enums"]["shop_item_kind"]
          user_id: string
        }
        Insert: {
          acquired_at?: string
          equipped?: boolean
          item_id: number
          item_kind: Database["public"]["Enums"]["shop_item_kind"]
          user_id: string
        }
        Update: {
          acquired_at?: string
          equipped?: boolean
          item_id?: number
          item_kind?: Database["public"]["Enums"]["shop_item_kind"]
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "inventory_item_id_fkey"
            columns: ["item_id"]
            isOneToOne: false
            referencedRelation: "shop_items"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "inventory_item_id_item_kind_fkey"
            columns: ["item_id", "item_kind"]
            isOneToOne: false
            referencedRelation: "shop_items"
            referencedColumns: ["id", "kind"]
          },
          {
            foreignKeyName: "inventory_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      orders: {
        Row: {
          amount_cents: number
          created_at: string
          creatine_amount: number
          credited_at: string | null
          currency: string
          id: string
          pack_slug: string
          status: Database["public"]["Enums"]["order_status"]
          stripe_session_id: string
          user_id: string
        }
        Insert: {
          amount_cents: number
          created_at?: string
          creatine_amount: number
          credited_at?: string | null
          currency?: string
          id?: string
          pack_slug: string
          status?: Database["public"]["Enums"]["order_status"]
          stripe_session_id: string
          user_id: string
        }
        Update: {
          amount_cents?: number
          created_at?: string
          creatine_amount?: number
          credited_at?: string | null
          currency?: string
          id?: string
          pack_slug?: string
          status?: Database["public"]["Enums"]["order_status"]
          stripe_session_id?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "orders_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      profiles: {
        Row: {
          avatar_url: string | null
          created_at: string
          creatine_balance: number
          display_name: string
          id: string
        }
        Insert: {
          avatar_url?: string | null
          created_at?: string
          creatine_balance?: number
          display_name: string
          id: string
        }
        Update: {
          avatar_url?: string | null
          created_at?: string
          creatine_balance?: number
          display_name?: string
          id?: string
        }
        Relationships: []
      }
      shop_items: {
        Row: {
          active: boolean
          id: number
          kind: Database["public"]["Enums"]["shop_item_kind"]
          name: string
          price_creatine: number
          slug: string
        }
        Insert: {
          active?: boolean
          id?: never
          kind: Database["public"]["Enums"]["shop_item_kind"]
          name: string
          price_creatine: number
          slug: string
        }
        Update: {
          active?: boolean
          id?: never
          kind?: Database["public"]["Enums"]["shop_item_kind"]
          name?: string
          price_creatine?: number
          slug?: string
        }
        Relationships: []
      }
      workout_sets: {
        Row: {
          exercise_id: number
          id: string
          reps: number
          rpe: number | null
          set_index: number
          weight_kg: number
          workout_id: string
        }
        Insert: {
          exercise_id: number
          id?: string
          reps: number
          rpe?: number | null
          set_index: number
          weight_kg: number
          workout_id: string
        }
        Update: {
          exercise_id?: number
          id?: string
          reps?: number
          rpe?: number | null
          set_index?: number
          weight_kg?: number
          workout_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "workout_sets_exercise_id_fkey"
            columns: ["exercise_id"]
            isOneToOne: false
            referencedRelation: "exercises"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "workout_sets_workout_id_fkey"
            columns: ["workout_id"]
            isOneToOne: false
            referencedRelation: "workout_feed"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "workout_sets_workout_id_fkey"
            columns: ["workout_id"]
            isOneToOne: false
            referencedRelation: "workouts"
            referencedColumns: ["id"]
          },
        ]
      }
      workouts: {
        Row: {
          created_at: string
          duration_min: number
          external_id: string | null
          havura_id: string
          id: string
          notes: string | null
          performed_at: string
          score: number
          source: Database["public"]["Enums"]["workout_source"]
          title: string
          user_id: string
        }
        Insert: {
          created_at?: string
          duration_min: number
          external_id?: string | null
          havura_id: string
          id?: string
          notes?: string | null
          performed_at: string
          score?: number
          source?: Database["public"]["Enums"]["workout_source"]
          title: string
          user_id: string
        }
        Update: {
          created_at?: string
          duration_min?: number
          external_id?: string | null
          havura_id?: string
          id?: string
          notes?: string | null
          performed_at?: string
          score?: number
          source?: Database["public"]["Enums"]["workout_source"]
          title?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "workouts_havura_id_fkey"
            columns: ["havura_id"]
            isOneToOne: false
            referencedRelation: "havuras"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "workouts_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Views: {
      active_arrivals: {
        Row: {
          announced_at: string | null
          display_name: string | null
          expires_at: string | null
          havura_id: string | null
          id: string | null
          note: string | null
          status: Database["public"]["Enums"]["arrival_status"] | null
          user_id: string | null
        }
        Relationships: [
          {
            foreignKeyName: "arrivals_havura_id_fkey"
            columns: ["havura_id"]
            isOneToOne: false
            referencedRelation: "havuras"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "arrivals_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      weekly_user_stats: {
        Row: {
          havura_id: string | null
          muscles_hit: number | null
          total_score: number | null
          total_volume: number | null
          user_id: string | null
          week_start: string | null
          workout_count: number | null
        }
        Relationships: [
          {
            foreignKeyName: "workouts_havura_id_fkey"
            columns: ["havura_id"]
            isOneToOne: false
            referencedRelation: "havuras"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "workouts_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      workout_feed: {
        Row: {
          created_at: string | null
          display_name: string | null
          duration_min: number | null
          havura_id: string | null
          id: string | null
          muscles: Database["public"]["Enums"]["muscle_group"][] | null
          notes: string | null
          performed_at: string | null
          score: number | null
          set_count: number | null
          source: Database["public"]["Enums"]["workout_source"] | null
          title: string | null
          user_id: string | null
          volume: number | null
        }
        Relationships: [
          {
            foreignKeyName: "workouts_havura_id_fkey"
            columns: ["havura_id"]
            isOneToOne: false
            referencedRelation: "havuras"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "workouts_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Functions: {
      announce_arrival: {
        Args: {
          p_havura_id: string
          p_note?: string
          p_status?: Database["public"]["Enums"]["arrival_status"]
        }
        Returns: string
      }
      apply_creatine: {
        Args: {
          p_delta: number
          p_reason: Database["public"]["Enums"]["ledger_reason"]
          p_ref_id?: string
          p_ref_type?: string
          p_user_id: string
        }
        Returns: number
      }
      close_arrival: { Args: { p_havura_id: string }; Returns: undefined }
      compute_workout_score: { Args: { p_workout_id: string }; Returns: number }
      create_havura: { Args: { p_name: string }; Returns: string }
      equip_item: { Args: { p_item_id: number }; Returns: undefined }
      generate_invite_code: { Args: never; Returns: string }
      is_havura_member: { Args: { p_havura_id: string }; Returns: boolean }
      is_havura_owner: { Args: { p_havura_id: string }; Returns: boolean }
      join_havura: { Args: { p_code: string }; Returns: string }
      log_workout: {
        Args: {
          p_duration_min: number
          p_havura_id: string
          p_notes: string
          p_performed_at: string
          p_sets: Json
          p_title: string
        }
        Returns: string
      }
      purchase_shop_item: { Args: { p_item_id: number }; Returns: undefined }
      shares_havura_with: { Args: { p_user_id: string }; Returns: boolean }
    }
    Enums: {
      arrival_status: "on_the_way" | "training"
      challenge_kind: "workout_count" | "total_volume" | "muscle_coverage"
      competition_metric: "total_score" | "workout_count" | "total_volume"
      competition_status: "open" | "settled"
      equipment_type:
        | "barbell"
        | "dumbbell"
        | "machine"
        | "cable"
        | "bodyweight"
        | "kettlebell"
        | "resistance_band"
        | "none"
      havura_role: "owner" | "member"
      ledger_reason:
        | "signup_bonus"
        | "challenge_reward"
        | "competition_payout"
        | "shop_purchase"
        | "pack_purchase"
        | "admin_adjust"
      movement_pattern:
        | "push_horizontal"
        | "push_vertical"
        | "pull_horizontal"
        | "pull_vertical"
        | "squat"
        | "hinge"
        | "lunge"
        | "carry"
        | "rotation"
        | "static"
      muscle_group:
        | "chest"
        | "back"
        | "shoulders"
        | "legs"
        | "glutes"
        | "core"
        | "biceps"
        | "triceps"
        | "cardio"
      order_status: "pending" | "paid" | "failed" | "expired"
      shop_item_kind: "title" | "badge" | "theme"
      workout_source: "manual" | "hevy"
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {
      arrival_status: ["on_the_way", "training"],
      challenge_kind: ["workout_count", "total_volume", "muscle_coverage"],
      competition_metric: ["total_score", "workout_count", "total_volume"],
      competition_status: ["open", "settled"],
      equipment_type: [
        "barbell",
        "dumbbell",
        "machine",
        "cable",
        "bodyweight",
        "kettlebell",
        "resistance_band",
        "none",
      ],
      havura_role: ["owner", "member"],
      ledger_reason: [
        "signup_bonus",
        "challenge_reward",
        "competition_payout",
        "shop_purchase",
        "pack_purchase",
        "admin_adjust",
      ],
      movement_pattern: [
        "push_horizontal",
        "push_vertical",
        "pull_horizontal",
        "pull_vertical",
        "squat",
        "hinge",
        "lunge",
        "carry",
        "rotation",
        "static",
      ],
      muscle_group: [
        "chest",
        "back",
        "shoulders",
        "legs",
        "glutes",
        "core",
        "biceps",
        "triceps",
        "cardio",
      ],
      order_status: ["pending", "paid", "failed", "expired"],
      shop_item_kind: ["title", "badge", "theme"],
      workout_source: ["manual", "hevy"],
    },
  },
} as const

