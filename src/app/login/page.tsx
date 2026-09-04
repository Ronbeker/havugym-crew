import Link from 'next/link';
import { DumbbellIcon } from '@/components/icons';
import { LoginForm } from './login-form';

export const metadata = { title: 'Sign in · HavuGym Crew' };

export default function LoginPage() {
  return (
    <main className="mx-auto flex min-h-dvh w-full max-w-md flex-col justify-center gap-8 px-5 py-12">
      <Link href="/" className="flex items-center gap-2.5 text-text">
        <DumbbellIcon className="h-6 w-6 text-accent" />
        <span className="text-lg font-semibold tracking-tight">HavuGym Crew</span>
      </Link>
      <LoginForm />
      <p className="text-center text-xs text-muted">
        Your workouts are visible only to the crews you join.
      </p>
    </main>
  );
}
