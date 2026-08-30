-- =============================================================================
-- 0004_seed_exercises.sql — the exercise catalogue: 660 rows.
--
-- Curated first-party data, exported from the production HavuGym catalogue.
-- Every row carries a primary muscle, secondary muscles, equipment, movement
-- pattern and written coaching instructions. This is what lets the logger ship
-- with a real exercise picker on day one, and what powers the muscle-coverage
-- component of the intensity score and the next-session recommendation.
-- =============================================================================

insert into public.exercises
  (slug, name, muscle_primary, muscle_secondary, equipment, movement_pattern, is_unilateral, default_rest_seconds, instructions)
values
  ('barbell_bench_press', 'Barbell Bench Press', 'chest', array['triceps','shoulders']::muscle_group[], 'barbell', 'push_horizontal', false, 180, '1. Set bar at chest height in rack, lie back with eyes under bar.
2. Grip shoulder-width plus a fist, unrack with arms straight.
3. Lower to lower-chest with elbows at ~75° from torso.
4. Press back to lockout, maintaining leg drive.'),
  ('incline_barbell_bench_press', 'Incline Barbell Bench Press', 'chest', array['triceps','shoulders']::muscle_group[], 'barbell', 'push_horizontal', false, 180, '1. Set bench to 30-45°, grip slightly wider than shoulder-width.
2. Unrack bar and lower to upper chest.
3. Press up and slightly back toward the rack.
4. Keep shoulder blades pinched and feet flat throughout.'),
  ('decline_barbell_bench_press', 'Decline Barbell Bench Press', 'chest', array['triceps']::muscle_group[], 'barbell', 'push_horizontal', false, 180, '1. Hook feet under ankle pads on decline bench, set grip wider than shoulder-width.
2. Unrack bar and lower to lower chest.
3. Press up explosively to lockout.
4. Keep wrists stacked over elbows throughout.'),
  ('close_grip_bench_press', 'Close Grip Bench Press', 'triceps', array['chest','shoulders']::muscle_group[], 'barbell', 'push_horizontal', false, 150, '1. Lie on flat bench, grip bar with hands ~shoulder-width apart.
2. Unrack and lower bar to lower chest/sternum with elbows tucked.
3. Press back to lockout, feeling triceps engage.
4. Maintain tight core and leg drive.'),
  ('dumbbell_bench_press', 'Dumbbell Bench Press', 'chest', array['triceps','shoulders']::muscle_group[], 'dumbbell', 'push_horizontal', false, 150, '1. Sit on bench with dumbbells on thighs, kick up to chest and lie back.
2. Press dumbbells up to lockout, neutral wrist over elbows.
3. Lower with control until upper arms are parallel with floor.
4. Press back up, touching dumbbells lightly at top.'),
  ('incline_dumbbell_bench_press', 'Incline Dumbbell Bench Press', 'chest', array['triceps','shoulders']::muscle_group[], 'dumbbell', 'push_horizontal', false, 150, '1. Set bench to 30-45°, sit and kick dumbbells to chest.
2. Press dumbbells overhead with palms forward.
3. Lower until upper arms are parallel with floor.
4. Press back to lockout, squeezing chest at top.'),
  ('chest_fly_dumbbell', 'Chest Fly (Dumbbell)', 'chest', '{}'::muscle_group[], 'dumbbell', 'push_horizontal', false, 90, '1. Lie flat, press dumbbells to lockout, palms facing each other.
2. With slight elbow bend, lower dumbbells in wide arc to shoulder height.
3. Feel stretch in chest then squeeze to bring dumbbells back together.
4. Do not straighten elbows; maintain the arc throughout.'),
  ('chest_fly_cable', 'Cable Chest Fly', 'chest', '{}'::muscle_group[], 'cable', 'push_horizontal', false, 90, '1. Set cables at shoulder height, stand in split stance between the towers.
2. With slight elbow bend, pull handles together in front of chest.
3. Squeeze pecs hard at midpoint.
4. Return with control, fully stretching chest.'),
  ('pec_deck', 'Pec Deck', 'chest', '{}'::muscle_group[], 'machine', 'push_horizontal', false, 90, '1. Adjust seat so handles are at mid-chest height.
2. Place forearms on pads, elbows at 90°.
3. Squeeze pads together until forearms touch or nearly touch.
4. Return with control, feeling chest stretch.'),
  ('chest_press_machine', 'Chest Press Machine', 'chest', array['triceps','shoulders']::muscle_group[], 'machine', 'push_horizontal', false, 90, '1. Adjust seat so handles are at mid-chest height.
2. Grip handles and press forward to full arm extension.
3. Squeeze chest at the lockout.
4. Return slowly to starting position.'),
  ('incline_chest_press_machine', 'Incline Chest Press Machine', 'chest', array['triceps','shoulders']::muscle_group[], 'machine', 'push_horizontal', false, 90, '1. Adjust seat height so handles are at upper-chest level.
2. Press handles up and away in an arc.
3. Squeeze upper chest at lockout.
4. Return slowly, fully stretching pecs.'),
  ('push_up', 'Push-Up', 'chest', array['triceps','shoulders','core']::muscle_group[], 'bodyweight', 'push_horizontal', false, 60, '1. Place hands shoulder-width apart, body in a straight line from head to heels.
2. Lower chest to just above the floor with elbows at ~45° from torso.
3. Press back to lockout, maintaining rigid core.
4. Do not let hips sag or pike.'),
  ('dips', 'Dips', 'triceps', array['chest','shoulders']::muscle_group[], 'bodyweight', 'push_vertical', false, 120, '1. Grip parallel bars, press to lockout.
2. Keep torso upright for tricep focus (lean forward for chest).
3. Lower until upper arms are parallel with floor.
4. Press back to lockout.'),
  ('weighted_dips', 'Weighted Dips', 'triceps', array['chest','shoulders']::muscle_group[], 'bodyweight', 'push_vertical', false, 150, '1. Attach weight via belt or hold dumbbell between feet.
2. Grip bars with arms locked, lean forward for chest emphasis.
3. Lower until upper arms are parallel with floor.
4. Press powerfully back to lockout.'),
  ('pullover_dumbbell', 'Dumbbell Pullover', 'chest', array['back','triceps']::muscle_group[], 'dumbbell', 'push_horizontal', false, 90, '1. Lie across bench with shoulders on pad, feet flat on floor.
2. Hold one dumbbell with both hands over chest, arms slightly bent.
3. Lower dumbbell in arc behind head until arms are parallel with floor.
4. Pull back over chest, squeezing chest and lats.'),
  ('barbell_deadlift', 'Barbell Deadlift', 'back', array['legs','glutes','core']::muscle_group[], 'barbell', 'hinge', false, 240, '1. Bar over mid-foot, hip-width stance, grip just outside legs.
2. Hinge to bar with flat back, hips above knees.
3. Drive through floor, bar stays close to legs the whole way.
4. Lock out hips and knees simultaneously at top.'),
  ('romanian_deadlift', 'Romanian Deadlift', 'back', array['glutes','legs']::muscle_group[], 'barbell', 'hinge', false, 180, '1. Stand with bar at hip, shoulder-width overhand grip.
2. Hinge at hips, pushing them back, keeping bar close to legs.
3. Lower until hamstrings are fully stretched (mid-shin for most).
4. Drive hips forward to return to standing.'),
  ('stiff_leg_deadlift', 'Stiff Leg Deadlift', 'back', array['glutes','legs']::muscle_group[], 'barbell', 'hinge', false, 180, '1. Stand with slight knee bend, gripping bar shoulder-width.
2. Hinge forward keeping legs nearly straight, bar close to shins.
3. Feel deep hamstring stretch at bottom.
4. Return to standing by squeezing glutes and extending hips.'),
  ('sumo_deadlift', 'Sumo Deadlift', 'legs', array['back','glutes']::muscle_group[], 'barbell', 'hinge', false, 240, '1. Wide stance, toes out at ~45°, grip inside legs.
2. Chest up, hips low, sit into the start.
3. Drive feet apart and press hips through.
4. Lock out at top.'),
  ('bent_over_barbell_row', 'Bent Over Barbell Row', 'back', array['biceps','shoulders']::muscle_group[], 'barbell', 'pull_horizontal', false, 180, '1. Hinge to ~45° torso angle, overhand grip shoulder-width.
2. Row bar to lower ribs, leading with elbows.
3. Squeeze shoulder blades at top.
4. Lower under control, fully extending arms.'),
  ('pendlay_row', 'Pendlay Row', 'back', array['biceps','shoulders']::muscle_group[], 'barbell', 'pull_horizontal', false, 180, '1. Bar rests on floor; hinge to parallel torso, grip shoulder-width.
2. Row explosively from dead stop on floor to lower ribs.
3. Lower bar back to floor between every rep.
4. Pause briefly on floor — no bounce.'),
  ('dumbbell_row', 'Single Arm Dumbbell Row', 'back', array['biceps']::muscle_group[], 'dumbbell', 'pull_horizontal', true, 90, '1. Plant one hand and knee on bench, opposite foot on floor.
2. Hold dumbbell with free hand, torso parallel to floor.
3. Row dumbbell to hip crease, elbow tracking close to body.
4. Lower fully and repeat.'),
  ('cable_row_seated', 'Seated Cable Row', 'back', array['biceps']::muscle_group[], 'cable', 'pull_horizontal', false, 90, '1. Sit at cable station with feet braced, knees slightly bent.
2. Grip handle, sit tall with neutral spine.
3. Row handles to abdomen, squeezing shoulder blades together.
4. Return arms forward and let shoulders protract fully.'),
  ('t_bar_row', 'T-Bar Row', 'back', array['biceps']::muscle_group[], 'machine', 'pull_horizontal', false, 150, '1. Straddle bar in machine with chest on pad, grip handles.
2. Row handles to chest, leading with elbows.
3. Squeeze upper back at top.
4. Lower under control to full arm extension.'),
  ('pull_up', 'Pull-Up', 'back', array['biceps']::muscle_group[], 'bodyweight', 'pull_vertical', false, 120, '1. Hang from bar with overhand grip slightly wider than shoulder-width.
2. Depress and retract scapula, then pull chest to bar.
3. Lead with chest, not chin — full range of motion.
4. Lower with control to dead hang.'),
  ('weighted_pull_up', 'Weighted Pull-Up', 'back', array['biceps']::muscle_group[], 'bodyweight', 'pull_vertical', false, 150, '1. Attach weight via belt, hang from bar shoulder-width overhand grip.
2. Pull chest to bar, depressing and retracting scapula first.
3. Pause at top, squeeze lats and upper back.
4. Lower slowly to full hang.'),
  ('chin_up', 'Chin-Up', 'back', array['biceps']::muscle_group[], 'bodyweight', 'pull_vertical', false, 120, '1. Hang from bar with underhand (supinated) grip shoulder-width.
2. Curl chest to bar, keeping elbows close to torso.
3. Biceps and lats work together — feel both.
4. Lower to full dead hang.'),
  ('lat_pulldown', 'Lat Pulldown', 'back', array['biceps']::muscle_group[], 'cable', 'pull_vertical', false, 90, '1. Sit with thighs under pads, overhand grip wider than shoulder-width.
2. Lean back slightly, pull bar to upper chest.
3. Squeeze lats hard at bottom, elbows pointing down.
4. Return bar with control, feeling lat stretch at top.'),
  ('wide_grip_lat_pulldown', 'Wide Grip Lat Pulldown', 'back', array['biceps']::muscle_group[], 'cable', 'pull_vertical', false, 90, '1. Grip bar as wide as comfortable (beyond shoulder-width).
2. Lean back slightly, pull bar to upper chest.
3. Focus on driving elbows to hips.
4. Return fully, lats stretching under load.'),
  ('straight_arm_pulldown', 'Straight Arm Pulldown', 'back', '{}'::muscle_group[], 'cable', 'pull_vertical', false, 90, '1. Stand facing cable with high pulley, arms nearly straight, slight elbow bend.
2. Push bar or rope straight down to hips.
3. Squeeze lats hard at bottom.
4. Return with control, keeping arms straight.'),
  ('inverted_row', 'Inverted Row', 'back', array['biceps']::muscle_group[], 'bodyweight', 'pull_horizontal', false, 90, '1. Set bar at waist height in rack, lie below it.
2. Grip bar, body straight from heels to head.
3. Pull chest to bar, squeezing shoulder blades together.
4. Lower with control to full arm extension.'),
  ('face_pull', 'Face Pull', 'shoulders', array['back']::muscle_group[], 'cable', 'pull_horizontal', false, 60, '1. Set cable at face height with rope attachment.
2. Step back, hold rope with thumbs facing up.
3. Pull rope to face, hands separating and elbows rising above the rope.
4. Squeeze rear delts and external rotators at end range.'),
  ('rack_pull', 'Rack Pull', 'back', array['glutes','legs']::muscle_group[], 'barbell', 'hinge', false, 210, '1. Set bar just below knee height on safeties.
2. Grip just outside hips, flat back, hips hinge, not squat.
3. Drive hips forward to stand tall.
4. Lower bar back to pins under control.'),
  ('barbell_overhead_press', 'Barbell Overhead Press', 'shoulders', array['triceps','core']::muscle_group[], 'barbell', 'push_vertical', false, 180, '1. Bar at shoulder height in rack, grip just outside shoulders.
2. Unrack, brace core and glutes, press bar straight overhead.
3. Lock out with bar over ears, head pushed through.
4. Lower to collarbone in controlled descent.'),
  ('dumbbell_shoulder_press', 'Dumbbell Shoulder Press', 'shoulders', array['triceps']::muscle_group[], 'dumbbell', 'push_vertical', false, 150, '1. Sit upright, dumbbells at shoulder height, palms forward.
2. Press dumbbells overhead to lockout.
3. Touch or nearly touch at top.
4. Lower with control to shoulder height.'),
  ('arnold_press', 'Arnold Press', 'shoulders', array['triceps']::muscle_group[], 'dumbbell', 'push_vertical', false, 120, '1. Sit with dumbbells at chest, palms facing you.
2. As you press overhead, rotate palms forward.
3. At lockout, palms face forward.
4. Reverse the rotation on the way down.'),
  ('shoulder_press_machine', 'Shoulder Press Machine', 'shoulders', array['triceps']::muscle_group[], 'machine', 'push_vertical', false, 90, '1. Adjust seat so handles align with shoulders.
2. Press handles overhead to lockout.
3. Squeeze shoulders at top.
4. Lower with control to starting position.'),
  ('lateral_raise_dumbbell', 'Lateral Raise', 'shoulders', '{}'::muscle_group[], 'dumbbell', null, false, 60, '1. Stand tall, dumbbell in each hand at sides.
2. Raise both arms to shoulder height, slight elbow bend.
3. Lead with elbows, pour water from a glass at top.
4. Lower slowly, 3-4 seconds descent.'),
  ('lateral_raise_cable', 'Cable Lateral Raise', 'shoulders', '{}'::muscle_group[], 'cable', null, true, 60, '1. Set cable at ankle height, stand to the side.
2. Raise arm to shoulder height in a lateral arc.
3. Pause at top, squeeze medial deltoid.
4. Lower with control.'),
  ('lateral_raise_machine', 'Lateral Raise Machine', 'shoulders', '{}'::muscle_group[], 'machine', null, false, 60, '1. Sit in machine, adjust seat height.
2. Press arm pads or grip handles, raise arms to shoulder height.
3. Pause at top.
4. Return slowly.'),
  ('front_raise_dumbbell', 'Front Raise', 'shoulders', '{}'::muscle_group[], 'dumbbell', null, false, 60, '1. Stand with dumbbells in front of thighs, neutral grip.
2. Raise one or both dumbbells to shoulder height, arms straight.
3. Hold 1 second at top.
4. Lower slowly.'),
  ('rear_delt_fly_dumbbell', 'Rear Delt Fly', 'shoulders', array['back']::muscle_group[], 'dumbbell', null, false, 60, '1. Hinge forward to near-parallel torso, dumbbells hanging.
2. Raise arms out to sides with slight elbow bend.
3. Squeeze rear deltoids at top.
4. Lower with control.'),
  ('upright_row', 'Upright Row', 'shoulders', array['biceps']::muscle_group[], 'barbell', null, false, 90, '1. Stand with barbell at thighs, shoulder-width grip.
2. Pull bar up along body to chin height, elbows rising above wrists.
3. Hold 1 second at top.
4. Lower with control.'),
  ('shrug_barbell', 'Barbell Shrug', 'shoulders', array['back']::muscle_group[], 'barbell', null, false, 90, '1. Hold bar at thighs, overhand grip.
2. Shrug shoulders straight up toward ears.
3. Hold peak for 1 second.
4. Lower fully, depressing traps.'),
  ('shrug_dumbbell', 'Dumbbell Shrug', 'shoulders', array['back']::muscle_group[], 'dumbbell', null, false, 90, '1. Hold dumbbells at sides.
2. Shrug shoulders straight up toward ears.
3. Hold peak for 1 second.
4. Lower slowly.'),
  ('barbell_curl', 'Barbell Curl', 'biceps', '{}'::muscle_group[], 'barbell', null, false, 90, '1. Stand with barbell, underhand shoulder-width grip.
2. Pin elbows to sides, curl bar to shoulders.
3. Squeeze biceps at top.
4. Lower with control — full elbow extension at bottom.'),
  ('dumbbell_curl', 'Dumbbell Curl', 'biceps', '{}'::muscle_group[], 'dumbbell', null, true, 75, '1. Stand with dumbbells, arms at sides, palms forward.
2. Curl both dumbbells to shoulders, supinating at top.
3. Squeeze at top.
4. Lower with control.'),
  ('hammer_curl', 'Hammer Curl', 'biceps', '{}'::muscle_group[], 'dumbbell', null, true, 75, '1. Hold dumbbells with neutral grip (thumbs up).
2. Curl without rotating wrist, keeping neutral throughout.
3. Squeeze forearms and brachialis at top.
4. Lower fully.'),
  ('preacher_curl', 'Preacher Curl', 'biceps', '{}'::muscle_group[], 'barbell', null, false, 90, '1. Set on preacher bench, upper arms on pad, barbell at bottom.
2. Curl bar to shoulders, elbows on pad.
3. Squeeze biceps at top.
4. Lower fully — deep stretch at bottom.'),
  ('cable_curl', 'Cable Curl', 'biceps', '{}'::muscle_group[], 'cable', null, false, 75, '1. Set low cable with bar or EZ bar attachment.
2. Pin elbows to sides, curl handles up to shoulders.
3. Squeeze biceps hard at top.
4. Lower with control.'),
  ('incline_dumbbell_curl', 'Incline Dumbbell Curl', 'biceps', '{}'::muscle_group[], 'dumbbell', null, true, 75, '1. Sit on incline bench (~60°), arms hang straight down.
2. Curl dumbbells to shoulders from stretched position.
3. Supinate at top for full biceps contraction.
4. Lower fully — full stretch at bottom.'),
  ('reverse_curl', 'Reverse Curl', 'biceps', '{}'::muscle_group[], 'barbell', null, false, 75, '1. Hold barbell or dumbbells with overhand (pronated) grip.
2. Curl up, keeping wrists neutral.
3. Targets brachialis and brachioradialis.
4. Lower slowly.'),
  ('zottman_curl', 'Zottman Curl', 'biceps', '{}'::muscle_group[], 'dumbbell', null, true, 75, '1. Curl dumbbells up with supinated grip.
2. At top, rotate to pronated (overhand) grip.
3. Lower with overhand grip (reverse curl descent).
4. Rotate back to supinated at bottom.'),
  ('triceps_pushdown_cable', 'Triceps Pushdown', 'triceps', '{}'::muscle_group[], 'cable', null, false, 75, '1. Attach bar to high cable, stand close to stack.
2. Elbows pinned to sides, press bar down to full extension.
3. Squeeze triceps hard at lockout.
4. Return slowly, elbows stay pinned.'),
  ('overhead_triceps_extension_cable', 'Overhead Triceps Extension (Cable)', 'triceps', '{}'::muscle_group[], 'cable', null, false, 75, '1. Attach rope to high cable, turn away from stack.
2. Hold rope overhead with elbows pointing forward.
3. Extend arms overhead to lockout.
4. Return, bending elbows, feel triceps long head stretch.'),
  ('skullcrusher', 'Skullcrusher', 'triceps', '{}'::muscle_group[], 'barbell', null, false, 90, '1. Lie on bench, bar over chest, narrow overhand grip.
2. Lower bar toward forehead by bending only the elbows.
3. Feel long head stretch at bottom.
4. Extend elbows to lockout.'),
  ('triceps_extension_dumbbell', 'Overhead Triceps Extension (Dumbbell)', 'triceps', '{}'::muscle_group[], 'dumbbell', null, false, 75, '1. Hold one or two dumbbells overhead, elbows pointing forward.
2. Lower weight behind head by bending elbows.
3. Feel long head stretch at bottom.
4. Extend elbows to full lockout.'),
  ('triceps_kickback', 'Triceps Kickback', 'triceps', '{}'::muscle_group[], 'dumbbell', null, true, 60, '1. Hinge forward ~45°, upper arm parallel with floor.
2. Extend forearm back to full lockout, keeping upper arm stationary.
3. Squeeze triceps hard at lockout.
4. Return forearm to 90°.'),
  ('barbell_squat', 'Barbell Back Squat', 'legs', array['glutes','core']::muscle_group[], 'barbell', 'squat', false, 240, '1. Set bar at shoulder height in rack, bar on upper back.
2. Grip shoulder-width plus, unrack, step back.
3. Squat down to parallel (hip crease at or below knee).
4. Drive through heels back to standing.'),
  ('front_squat', 'Front Squat', 'legs', array['glutes','core']::muscle_group[], 'barbell', 'squat', false, 240, '1. Bar in front rack (elbows high), feet shoulder-width.
2. Squat to parallel with upright torso.
3. Drive knees out, keep elbows up.
4. Stand up through heels.'),
  ('goblet_squat', 'Goblet Squat', 'legs', array['glutes']::muscle_group[], 'dumbbell', 'squat', false, 120, '1. Hold dumbbell or kettlebell at chest, feet shoulder-width.
2. Squat deep, keeping chest up and elbows inside knees.
3. Use the weight as a counterbalance for upright torso.
4. Stand up pressing through heels.'),
  ('leg_press', 'Leg Press', 'legs', array['glutes']::muscle_group[], 'machine', 'squat', false, 150, '1. Sit in machine, feet shoulder-width on platform.
2. Unlock safety, lower platform to 90° at knee.
3. Press platform back to near lockout (don''t lock knees).
4. Control descent every rep.'),
  ('hack_squat', 'Hack Squat', 'legs', array['glutes']::muscle_group[], 'machine', 'squat', false, 150, '1. Set shoulders under pads, feet shoulder-width on platform.
2. Unlock and descend until thighs are parallel.
3. Press through heels to near-lockout.
4. Control every rep.'),
  ('leg_extension', 'Leg Extension', 'legs', '{}'::muscle_group[], 'machine', null, false, 75, '1. Sit in machine, adjust back pad, ankles on roller.
2. Extend legs to full lockout.
3. Squeeze quads at top, hold 1 second.
4. Lower with control — full range.'),
  ('leg_curl_seated', 'Seated Leg Curl', 'legs', '{}'::muscle_group[], 'machine', null, false, 75, '1. Sit in machine, adjust thigh pad, ankles above roller.
2. Curl legs down to full flexion.
3. Squeeze hamstrings at peak.
4. Return with control.'),
  ('leg_curl_lying', 'Lying Leg Curl', 'legs', '{}'::muscle_group[], 'machine', null, false, 75, '1. Lie face-down on machine, ankles under roller.
2. Curl heels toward glutes.
3. Squeeze hamstrings at peak.
4. Lower with control.'),
  ('calf_raise_standing', 'Standing Calf Raise', 'legs', '{}'::muscle_group[], 'machine', null, false, 60, '1. Stand on platform edge (heels hanging), hold weight.
2. Rise as high as possible on toes.
3. Hold at top for 1-2 seconds.
4. Lower heels below platform level for full stretch.'),
  ('lunge_barbell', 'Lunge', 'legs', array['glutes']::muscle_group[], 'barbell', 'squat', true, 120, '1. Bar on upper back, step one foot forward.
2. Lower back knee toward floor, front thigh to parallel.
3. Drive front heel to return to standing.
4. Alternate legs or do all reps on one side.'),
  ('bulgarian_split_squat', 'Bulgarian Split Squat', 'legs', array['glutes']::muscle_group[], 'dumbbell', 'squat', true, 150, '1. Rear foot elevated on bench, front foot forward.
2. Lower front knee toward floor, keeping front shin vertical.
3. Front thigh reaches parallel or below.
4. Drive through front heel to stand.'),
  ('box_squat', 'Box Squat', 'legs', array['glutes']::muscle_group[], 'barbell', 'squat', false, 210, '1. Bar on upper back, box behind at parallel height.
2. Sit back onto box, keep shins near vertical.
3. Pause on box with full tension, no relaxation.
4. Drive powerfully back to standing.'),
  ('smith_machine_squat', 'Smith Machine Squat', 'legs', array['glutes']::muscle_group[], 'machine', 'squat', false, 150, '1. Set bar at shoulder height, step into Smith machine.
2. Bar on upper back, feet slightly in front of bar.
3. Squat to parallel.
4. Drive through heels, release the safeties on the way back.'),
  ('barbell_hip_thrust', 'Barbell Hip Thrust', 'glutes', array['legs']::muscle_group[], 'barbell', 'hinge', false, 150, '1. Upper back on bench edge, bar over hip crease.
2. Feet flat, knees over ankles.
3. Drive hips to full extension, squeezing glutes hard.
4. Lower hips to near-floor.'),
  ('dumbbell_hip_thrust', 'Dumbbell Hip Thrust', 'glutes', array['legs']::muscle_group[], 'dumbbell', 'hinge', false, 120, '1. Upper back on bench edge, dumbbell on hip.
2. Feet flat shoulder-width.
3. Drive hips up to full extension.
4. Squeeze glutes at top, lower with control.'),
  ('glute_bridge', 'Glute Bridge', 'glutes', array['legs']::muscle_group[], 'bodyweight', 'hinge', false, 60, '1. Lie on floor, knees bent, feet flat.
2. Drive hips upward to full extension.
3. Squeeze glutes at top, hold 1-2 seconds.
4. Lower with control.'),
  ('good_morning', 'Good Morning', 'glutes', array['back','legs']::muscle_group[], 'barbell', 'hinge', false, 150, '1. Bar on upper back in squat position, stand tall.
2. Hinge at hips with slight knee bend, lowering torso to parallel.
3. Keep neutral spine throughout.
4. Drive hips forward to return to standing.'),
  ('cable_kickback', 'Cable Glute Kickback', 'glutes', '{}'::muscle_group[], 'cable', null, true, 60, '1. Attach ankle cuff to low cable, face stack.
2. Kick working leg straight back, squeezing glute.
3. Hold 1 second at peak.
4. Return with control.'),
  ('plank', 'Plank', 'core', array['shoulders']::muscle_group[], 'bodyweight', null, false, 60, '1. Forearms on floor, elbows under shoulders.
2. Body straight from head to heels, hips neither sagging nor piking.
3. Squeeze glutes and brace abs hard.
4. Hold for prescribed time, breathe normally.'),
  ('side_plank', 'Side Plank', 'core', '{}'::muscle_group[], 'bodyweight', null, true, 60, '1. Lie on side, prop on one forearm, feet stacked.
2. Lift hips so body is straight from head to heels.
3. Squeeze obliques, hold for prescribed time.
4. Switch sides.'),
  ('hanging_leg_raise', 'Hanging Leg Raise', 'core', '{}'::muscle_group[], 'bodyweight', null, false, 60, '1. Hang from bar with straight arms.
2. Raise legs to horizontal (or toes to bar for advanced).
3. Control the descent — do not swing.
4. Keep core tight throughout.'),
  ('cable_crunch', 'Cable Crunch', 'core', '{}'::muscle_group[], 'cable', null, false, 60, '1. Kneel at high cable with rope at neck.
2. Crunch elbows toward knees, rounding spine.
3. Squeeze abs at bottom.
4. Return slowly, feel abs stretch.'),
  ('ab_wheel_rollout', 'Ab Wheel Rollout', 'core', array['shoulders']::muscle_group[], 'bodyweight', null, false, 90, '1. Kneel, hands on ab wheel, arms straight.
2. Roll wheel forward, lowering hips and extending spine.
3. Roll as far as possible while maintaining control.
4. Pull back to start using abs.'),
  ('crunch', 'Crunch', 'core', '{}'::muscle_group[], 'bodyweight', null, false, 60, '1. Lie on back, knees bent, hands behind head.
2. Curl upper spine off floor, bringing ribs toward hips.
3. Squeeze abs at top.
4. Lower with control — don''t fully relax between reps.'),
  ('sit_up', 'Sit-Up', 'core', '{}'::muscle_group[], 'bodyweight', null, false, 60, '1. Lie on back, knees bent, feet anchored.
2. Sit up fully by flexing hip flexors and abs.
3. Touch elbows to knees at top.
4. Lower slowly.'),
  ('russian_twist', 'Russian Twist', 'core', '{}'::muscle_group[], 'bodyweight', null, false, 60, '1. Sit with knees bent, lean back ~45°, feet elevated.
2. Rotate torso side to side holding weight.
3. Feel obliques engage each rotation.
4. Keep spine neutral, not hunched.'),
  ('dead_bug', 'Dead Bug', 'core', '{}'::muscle_group[], 'bodyweight', null, false, 60, '1. Lie on back, arms up, knees bent at 90°.
2. Lower opposite arm and leg simultaneously toward floor.
3. Keep lower back pressed to floor.
4. Return and alternate sides.'),
  ('woodchop_cable', 'Cable Wood Chop', 'core', array['shoulders']::muscle_group[], 'cable', null, true, 60, '1. Set cable high, stand sideways.
2. Pull cable downward diagonally across body.
3. Rotate through core, twist from high to low.
4. Return with control.'),
  ('clean_and_jerk', 'Clean and Jerk', 'shoulders', array['legs','back','core']::muscle_group[], 'barbell', 'squat', false, 240, '1. Deadlift bar off floor, explosively extend hips and pull bar up.
2. Drop into front squat position, catching bar on shoulders.
3. Stand from front squat (the clean).
4. Dip and drive bar overhead, catching in split jerk stance.'),
  ('hang_snatch', 'Hang Snatch', 'shoulders', array['back','legs']::muscle_group[], 'barbell', 'squat', false, 240, '1. Hold bar at hips with wide snatch grip.
2. Dip slightly and explosively extend hips, shrug, and pull bar up.
3. Pull under and catch bar overhead in squat.
4. Stand to lockout.'),
  ('farmers_carry', 'Farmer''s Carry', 'core', array['shoulders','back']::muscle_group[], 'dumbbell', 'carry', false, 90, '1. Pick up heavy dumbbells or kettlebells, stand tall.
2. Walk with controlled stride, maintaining upright posture.
3. Core braced, shoulders down and back.
4. Walk for prescribed distance.'),
  ('suitcase_carry', 'Suitcase Carry', 'core', array['shoulders']::muscle_group[], 'dumbbell', 'carry', true, 90, '1. Hold weight in one hand at side (like a suitcase).
2. Walk upright, resisting lateral lean.
3. Core braces hard against offset load.
4. Walk for distance, then switch sides.'),
  ('muscle_up', 'Muscle-Up', 'back', array['biceps','triceps','shoulders']::muscle_group[], 'bodyweight', 'pull_vertical', false, 150, '1. Hang from bar or rings.
2. Pull explosively and transition over the bar (or rings).
3. Dip to full lockout above the bar.
4. Lower with control.'),
  ('bench_press_smith', 'Smith Machine Bench Press', 'chest', array['triceps','shoulders']::muscle_group[], 'machine', 'push_horizontal', false, 150, '1. Lie on bench with Smith machine bar over lower chest.
2. Unhook bar, lower to chest.
3. Press to lockout.
4. Re-hook the safety hooks.'),
  ('overhead_press_smith', 'Smith Machine Overhead Press', 'shoulders', array['triceps']::muscle_group[], 'machine', 'push_vertical', false, 150, '1. Set bar at shoulder height, sit or stand.
2. Grip shoulder-width, unhook and press overhead.
3. Lock out.
4. Return to shoulders.'),
  ('row_smith', 'Smith Machine Row', 'back', array['biceps']::muscle_group[], 'machine', 'pull_horizontal', false, 120, '1. Set bar at hip height, grip and hinge to row position.
2. Row bar to abdomen.
3. Squeeze upper back.
4. Lower with control.'),
  ('kettlebell_swing', 'Kettlebell Swing', 'glutes', array['back','core','shoulders']::muscle_group[], 'kettlebell', 'hinge', false, 90, '1. Hinge at hips, grip bell with both hands, bell between knees.
2. Explosively extend hips, letting bell float to chest height.
3. Hinge again as bell descends.
4. Generate power from hips, not arms.'),
  ('kettlebell_goblet_squat', 'Kettlebell Goblet Squat', 'legs', array['glutes']::muscle_group[], 'kettlebell', 'squat', false, 90, '1. Hold kettlebell at chest with both hands, feet shoulder-width.
2. Squat deep, elbows inside knees, chest tall.
3. Use bell as counterbalance.
4. Drive through heels to stand.'),
  ('kettlebell_press', 'Kettlebell Press', 'shoulders', array['triceps','core']::muscle_group[], 'kettlebell', 'push_vertical', true, 90, '1. Clean bell to rack position at shoulder.
2. Press overhead to lockout.
3. Pull bell back to rack in controlled descent.
4. Repeat on same side or alternate.'),
  ('kettlebell_row', 'Kettlebell Row', 'back', array['biceps']::muscle_group[], 'kettlebell', 'pull_horizontal', true, 90, '1. Hinge at ~45°, hold kettlebell in one hand.
2. Row to hip, elbow tracking close.
3. Squeeze at top.
4. Lower fully.'),
  ('turkish_getup', 'Turkish Get-Up', 'core', array['shoulders','legs']::muscle_group[], 'kettlebell', null, true, 120, '1. Lie with kettlebell pressed overhead, same-side knee bent.
2. Roll to elbow, then hand, sweep leg through.
3. Stand via a kneeling position, keeping weight overhead.
4. Reverse each step to return to floor.'),
  ('resistance_band_bicep_curl', 'Resistance Band Bicep Curl', 'biceps', '{}'::muscle_group[], 'resistance_band', null, false, 60, '1. Stand on band, hold ends with supinated grip.
2. Curl hands to shoulders, elbows pinned.
3. Squeeze at top.
4. Lower with control.'),
  ('resistance_band_pull_apart', 'Band Pull-Apart', 'shoulders', array['back']::muscle_group[], 'resistance_band', null, false, 60, '1. Hold band at shoulder width, arms straight in front.
2. Pull band apart until hands are at sides.
3. Squeeze rear delts and rhomboids.
4. Return with control.'),
  ('resistance_band_triceps', 'Resistance Band Triceps Extension', 'triceps', '{}'::muscle_group[], 'resistance_band', null, false, 60, '1. Stand on band, hold behind head with both hands.
2. Extend elbows overhead to lockout.
3. Squeeze triceps at lockout.
4. Return with control.'),
  ('resistance_band_row', 'Resistance Band Row', 'back', array['biceps']::muscle_group[], 'resistance_band', 'pull_horizontal', false, 60, '1. Anchor band at chest height, grip ends.
2. Row hands to sides, squeezing shoulder blades.
3. Maintain upright posture.
4. Return with control.'),
  ('floor_press', 'Floor Press', 'chest', array['triceps','shoulders']::muscle_group[], 'barbell', 'push_horizontal', false, 150, '1. Lie on floor with dumbbells or barbell, upper arms resting on floor.
2. Press to lockout, arms fully extended.
3. Lower until triceps touch floor — no bounce.
4. Press again. Natural elbow tuck due to floor.'),
  ('zercher_squat', 'Zercher Squat', 'legs', array['core','back']::muscle_group[], 'barbell', 'squat', false, 210, '1. Hold bar in the crooks of your elbows, forearms crossed.
2. Stand with feet shoulder-width, squat to parallel or below.
3. Keep chest tall, elbows rise as you descend.
4. Drive through heels.'),
  ('overhead_squat', 'Overhead Squat', 'legs', array['shoulders','core']::muscle_group[], 'barbell', 'squat', false, 210, '1. Hold bar overhead with snatch grip, arms locked.
2. Feet shoulder-width, squat with bar overhead throughout.
3. Requires significant mobility.
4. Drive through heels.'),
  ('step_up', 'Step-Up', 'legs', array['glutes']::muscle_group[], 'dumbbell', 'squat', true, 90, '1. Stand in front of box, hold weight or use bodyweight.
2. Step one foot onto box fully.
3. Drive through the top foot to stand on box.
4. Step down and alternate legs.'),
  ('leg_raise_parallel', 'Parallel Bar Leg Raise', 'core', '{}'::muscle_group[], 'bodyweight', null, false, 60, '1. Grip parallel bars, support weight on forearms.
2. Raise legs to horizontal.
3. Squeeze abs at top.
4. Lower with control.'),
  ('v_up', 'V-Up', 'core', '{}'::muscle_group[], 'bodyweight', null, false, 60, '1. Lie flat, arms overhead.
2. Simultaneously raise legs and torso, reaching hands to feet.
3. Balance on tailbone at top.
4. Lower both ends with control.'),
  ('bicycle_crunch', 'Bicycle Crunch', 'core', '{}'::muscle_group[], 'bodyweight', null, false, 60, '1. Lie on back, hands behind head, knees bent.
2. Crunch while rotating to touch elbow to opposite knee.
3. Extend the other leg at the same time.
4. Alternate sides in a pedaling motion.'),
  ('mountain_climber', 'Mountain Climber', 'core', array['cardio']::muscle_group[], 'bodyweight', null, false, 60, '1. Start in push-up position, body straight.
2. Drive one knee to chest, then quickly alternate.
3. Maintain rigid core, do not let hips rise.
4. Fast or slow — both work core.'),
  ('box_jump', 'Box Jump', 'legs', array['glutes','cardio']::muscle_group[], 'bodyweight', 'squat', false, 60, '1. Stand in front of a box, feet shoulder-width.
2. Dip slightly and swing arms.
3. Jump explosively, landing softly on box in squat position.
4. Step down carefully.'),
  ('pike_push_up', 'Pike Push-Up', 'shoulders', array['triceps']::muscle_group[], 'bodyweight', 'push_vertical', false, 60, '1. Start in down-dog position — hips high, body forms inverted V.
2. Bend elbows and lower head toward floor.
3. Press back to start, feeling shoulders and triceps work.
4. Maintain high-hip pike position throughout.'),
  ('diamond_push_up', 'Diamond Push-Up', 'triceps', array['chest']::muscle_group[], 'bodyweight', 'push_horizontal', false, 60, '1. Place hands together under chest forming a diamond with thumbs and index fingers.
2. Lower chest toward hands, elbows tight to torso.
3. Press back to lockout, squeezing triceps.
4. Maintain rigid core throughout.'),
  ('wrist_curl', 'Wrist Curl', 'biceps', '{}'::muscle_group[], 'barbell', null, false, 60, '1. Sit with forearm resting on thigh, palm up.
2. Hold dumbbell, let wrist extend fully.
3. Curl wrist upward, flexing forearm.
4. Lower with control.'),
  ('reverse_wrist_curl', 'Reverse Wrist Curl', 'biceps', '{}'::muscle_group[], 'barbell', null, false, 60, '1. Sit with forearm on thigh, palm down.
2. Hold dumbbell, let wrist flex downward.
3. Extend wrist upward.
4. Lower with control.'),
  ('cable_crossover', 'Cable Crossover', 'chest', '{}'::muscle_group[], 'cable', 'push_horizontal', false, 75, '1. Set cable pulleys at shoulder height, stand in cable station center.
2. With slight elbow bend, pull handles together and downward in front of hips.
3. Squeeze pecs hard at midpoint, hold 1 second.
4. Return in arc with control.'),
  ('low_to_high_cable_fly', 'Low to High Cable Fly', 'chest', '{}'::muscle_group[], 'cable', 'push_horizontal', false, 75, '1. Set pulleys at ankle height, stand in cable station center.
2. With slight elbow bend, pull handles up and together in front of upper chest.
3. Squeeze upper chest at top.
4. Return to start with control.'),
  ('high_to_low_cable_fly', 'High to Low Cable Fly', 'chest', '{}'::muscle_group[], 'cable', 'push_horizontal', false, 75, '1. Set pulleys above head, stand in cable station center.
2. Pull handles down and together in front of lower chest.
3. Squeeze lower pecs at bottom.
4. Return with control.'),
  ('landmine_press', 'Landmine Press', 'shoulders', array['chest','core']::muscle_group[], 'barbell', 'push_vertical', true, 120, '1. Anchor barbell in landmine, grip collar end at shoulder level.
2. Press bar up and away in an arc.
3. Lock out, bar at about eye level.
4. Return with control.'),
  ('landmine_row', 'Landmine Row', 'back', array['biceps']::muscle_group[], 'barbell', 'pull_horizontal', true, 120, '1. Anchor bar in landmine, hinge to grip collar end.
2. Row bar to hip with one hand.
3. Squeeze at top.
4. Lower fully.'),
  ('seated_dumbbell_curl', 'Seated Dumbbell Curl', 'biceps', '{}'::muscle_group[], 'dumbbell', null, true, 75, '1. Sit on bench with back support, dumbbells at sides.
2. Curl with supination as you raise.
3. Squeeze at top.
4. Lower with control.'),
  ('spider_curl', 'Spider Curl', 'biceps', '{}'::muscle_group[], 'barbell', null, false, 75, '1. Lie face-down on incline bench, arms hanging straight down.
2. Curl bar or dumbbells to chin.
3. Peak contraction at top.
4. Lower with control.'),
  ('rear_delt_cable_fly', 'Rear Delt Cable Fly', 'shoulders', array['back']::muscle_group[], 'cable', null, false, 60, '1. Set cables at shoulder height, cross handles (left hand grabs right cable).
2. Step back, pull handles apart in a fly motion.
3. Squeeze rear delts at end range.
4. Return with control.'),
  ('cable_pullover', 'Cable Pullover', 'back', array['chest']::muscle_group[], 'cable', 'pull_vertical', false, 75, '1. Set high pulley with bar or rope, stand facing stack.
2. Grip bar with straight arms in front.
3. Pull bar down and back toward hips in an arc, arms nearly straight.
4. Return above head with control.'),
  ('chest_supported_row', 'Chest Supported Row', 'back', array['biceps']::muscle_group[], 'dumbbell', 'pull_horizontal', false, 90, '1. Lie face-down on incline bench, dumbbell in each hand.
2. Row dumbbells toward hips, leading with elbows.
3. Squeeze shoulder blades at top.
4. Lower fully, allowing scapula to protract.'),
  ('incline_dumbbell_row', 'Incline Dumbbell Row', 'back', array['biceps']::muscle_group[], 'dumbbell', 'pull_horizontal', false, 90, '1. Set bench to slight incline, lie face-down.
2. Hang dumbbells straight down.
3. Row to hips with elbows close, squeeze upper back.
4. Lower with control.'),
  ('single_leg_rdl', 'Single Leg Romanian Deadlift', 'glutes', array['legs','back']::muscle_group[], 'dumbbell', 'hinge', true, 120, '1. Stand on one leg, hinge at hip, lowering weight toward floor.
2. Keep back flat, opposite leg rises behind.
3. Feel hamstring stretch on standing leg.
4. Drive hip forward to return.'),
  ('sumo_squat_dumbbell', 'Sumo Squat', 'legs', array['glutes']::muscle_group[], 'dumbbell', 'squat', false, 120, '1. Hold dumbbell vertically with both hands, wide stance.
2. Squat down, elbows inside knees.
3. Press through heels to stand.
4. Keep chest up throughout.'),
  ('walking_lunge', 'Walking Lunge', 'legs', array['glutes']::muscle_group[], 'dumbbell', 'squat', true, 90, '1. Stand tall, step one foot forward into lunge position.
2. Lower back knee to near-floor level.
3. Drive front foot forward and step into the next lunge.
4. Continue walking alternately.'),
  ('reverse_lunge', 'Reverse Lunge', 'legs', array['glutes']::muscle_group[], 'dumbbell', 'squat', true, 90, '1. Stand tall, step one foot backward.
2. Lower back knee toward floor, front thigh to parallel.
3. Drive front heel to return to standing.
4. Alternate legs.'),
  ('leg_press_single', 'Single Leg Press', 'legs', array['glutes']::muscle_group[], 'machine', 'squat', true, 90, '1. Set one foot centered on platform, opposite leg aside.
2. Lower platform with single leg to 90° knee angle.
3. Press through heel back to near-lockout.
4. Control every rep.'),
  ('cable_triceps_extension', 'Cable Triceps Extension', 'triceps', '{}'::muscle_group[], 'cable', null, false, 75, '1. Attach bar or rope to high cable, face away from stack.
2. Hold overhead, elbows forward.
3. Extend arms to full lockout.
4. Return with control, elbows stationary.'),
  ('triceps_extension_machine', 'Triceps Extension Machine', 'triceps', '{}'::muscle_group[], 'machine', null, false, 75, '1. Sit in machine, adjust pads, grip handles.
2. Extend elbows to full lockout.
3. Squeeze at lockout.
4. Return with control.'),
  ('pull_over_machine', 'Pullover Machine', 'back', array['chest','triceps']::muscle_group[], 'machine', 'pull_vertical', false, 90, '1. Sit in machine, adjust for reach, grip bar overhead.
2. Pull bar forward and down to thighs in an arc.
3. Squeeze lats at bottom.
4. Return slowly to stretch.'),
  ('reverse_fly_pec_deck', 'Reverse Fly (Pec Deck)', 'shoulders', array['back']::muscle_group[], 'machine', null, false, 75, '1. Hold weight at sides or in front.
2. Raise to shoulder height, slight elbow bend.
3. Pause at top.
4. Lower slowly with control.'),
  ('glute_ham_raise', 'Glute Ham Raise', 'legs', array['glutes']::muscle_group[], 'machine', 'hinge', false, 120, '1. Set on GHD with hips on pad, ankles secured.
2. Lower torso toward floor using hamstrings and glutes.
3. Curl back to horizontal.
4. Full range — hip extension at top.'),
  ('nordic_hamstring_curl', 'Nordic Hamstring Curl', 'legs', '{}'::muscle_group[], 'bodyweight', 'hinge', false, 120, '1. Kneel with ankles secured, body upright.
2. Lower body toward floor by extending at the knee (very controlled).
3. Use hands to catch and push back if needed.
4. Return to kneeling by curling hamstrings.'),
  ('hip_abduction_machine', 'Hip Abduction Machine', 'glutes', array['legs']::muscle_group[], 'machine', null, false, 75, '1. Sit in machine, inner thighs against pads.
2. Push legs apart to full abduction.
3. Squeeze glutes and abductors at peak.
4. Return with control.'),
  ('hip_adduction_machine', 'Hip Adduction Machine', 'legs', array['glutes']::muscle_group[], 'machine', null, false, 75, '1. Sit in machine, outer thighs against pads.
2. Press legs together to full adduction.
3. Squeeze adductors at midpoint.
4. Return with control.'),
  ('renegade_row', 'Renegade Row', 'back', array['core','biceps']::muscle_group[], 'dumbbell', 'pull_horizontal', true, 90, '1. Start in push-up position with a dumbbell in each hand.
2. Perform a push-up, then row one dumbbell to hip.
3. Return dumbbell, perform push-up, row the other side.
4. Keep hips level throughout — brace core hard.'),
  ('bird_dog', 'Bird Dog', 'core', array['glutes']::muscle_group[], 'bodyweight', null, true, 60, '1. Start on hands and knees, neutral spine.
2. Extend opposite arm and leg simultaneously.
3. Pause and squeeze.
4. Return and alternate sides.'),
  ('hyperextension', 'Hyperextension', 'back', array['glutes']::muscle_group[], 'bodyweight', 'hinge', false, 75, '1. Secure ankles on hyperextension bench at 45°.
2. Arms crossed or hands behind head, lower torso toward floor.
3. Raise back to horizontal, squeezing glutes.
4. Avoid excessive hyperextension.'),
  ('cable_row_standing', 'Standing Cable Row', 'back', array['biceps','core']::muscle_group[], 'cable', 'pull_horizontal', false, 90, '1. Stand facing cable station, low pulley with rope or bar.
2. Brace core, hinge slightly, row to abdomen.
3. Squeeze shoulder blades together at the end.
4. Return with control.'),
  ('single_arm_cable_row', 'Single Arm Cable Row', 'back', array['biceps']::muscle_group[], 'cable', 'pull_horizontal', true, 75, '1. Set cable at chest height, grab single handle.
2. Step back in split stance, brace core.
3. Row handle to hip, rotating torso slightly.
4. Return to full arm extension, reset.'),
  ('triceps_dumbbell_skullcrusher', 'Dumbbell Skullcrusher', 'triceps', '{}'::muscle_group[], 'dumbbell', null, false, 90, '1. Hold dumbbells over chest, arms extended, slight inward angle.
2. Lower dumbbells toward temples by bending elbows.
3. Elbows stationary, feel long head stretch.
4. Extend to lockout.'),
  ('cable_bicep_curl_single', 'Single Arm Cable Curl', 'biceps', '{}'::muscle_group[], 'cable', null, true, 75, '1. Set low cable, stand facing stack.
2. Curl single handle with one arm, elbow pinned to side.
3. Squeeze at top.
4. Lower slowly.'),
  ('behind_the_back_barbell_curl', 'Behind the Back Barbell Curl', 'biceps', '{}'::muscle_group[], 'barbell', null, false, 75, '1. Stand with barbell behind back in reverse-grip rack.
2. Curl bar by flexing elbows behind body.
3. Short range but strong brachialis stretch.
4. Lower with control.'),
  ('pinwheel_curl', 'Pinwheel Curl', 'biceps', '{}'::muscle_group[], 'dumbbell', null, true, 75, '1. Hold dumbbells with neutral grip.
2. Alternately curl one dumbbell across body to opposite shoulder.
3. Targets brachialis, similar to cross-body hammer.
4. Return and alternate.'),
  ('landmine_squat', 'Landmine Squat', 'legs', array['glutes','core']::muscle_group[], 'barbell', 'squat', false, 150, '1. Hold end of barbell at chest level with both hands.
2. Feet shoulder-width, squat to parallel.
3. Keep chest up, elbows may touch knees.
4. Drive through heels.'),
  ('pendulum_squat', 'Pendulum Squat', 'legs', array['glutes']::muscle_group[], 'machine', 'squat', false, 150, '1. Set shoulders under pads, lean back slightly.
2. Squat down — machine guides the arc.
3. Very upright torso, deep quad stretch.
4. Press through heels.'),
  ('band_squat', 'Band Squat', 'legs', array['glutes']::muscle_group[], 'resistance_band', 'squat', false, 90, '1. Stand on band with feet shoulder-width, hold band handles at shoulders.
2. Squat to parallel.
3. Drive through heels to stand.
4. Band provides ascending resistance.'),
  ('pull_down_with_machine', 'Machine Lat Pulldown', 'back', array['biceps']::muscle_group[], 'machine', 'pull_vertical', false, 90, '1. Sit at machine and adjust thigh pads for stability.
2. Grip handles or bar at shoulder-width.
3. Pull handles down to chest level.
4. Return with control, feeling lat stretch.'),
  ('hanging_knee_raise', 'Hanging Knee Raise', 'core', '{}'::muscle_group[], 'bodyweight', null, false, 60, '1. Hang from bar, arms straight.
2. Raise knees to chest, curling pelvis.
3. Squeeze abs at top.
4. Lower under control.'),
  ('hip_circle', 'Hip Circle', 'glutes', '{}'::muscle_group[], 'resistance_band', null, false, 60, '1. Stand with feet shoulder-width, hands on hips.
2. Rotate hips in a wide circle, one direction.
3. 10 reps clockwise, then 10 counterclockwise.
4. Activates hip rotators and glutes.'),
  ('hip_thrust_smith', 'Smith Machine Hip Thrust', 'glutes', array['legs']::muscle_group[], 'machine', 'hinge', false, 120, '1. Set Smith bar at hip height for seated position.
2. Upper back on bench, push bar over hips.
3. Drive hips to full extension.
4. Lower with control.'),
  ('cable_hip_thrust', 'Cable Pull-Through', 'glutes', array['legs']::muscle_group[], 'cable', 'hinge', false, 90, '1. Anchor cable at low position, attach to hip via belt.
2. Get into hip thrust position with back on bench.
3. Drive hips to full extension.
4. Lower and repeat.'),
  ('cable_crunch_kneeling', 'Kneeling Cable Crunch', 'core', '{}'::muscle_group[], 'cable', null, false, 60, '1. Kneel at high cable with rope or handle.
2. Hold behind neck or at sides of head.
3. Crunch downward, bringing elbows toward knees.
4. Return slowly.'),
  ('pallof_press', 'Pallof Press', 'core', array['shoulders']::muscle_group[], 'cable', null, true, 60, '1. Set cable at chest height, stand sideways.
2. Hold handle at chest, press it straight out.
3. Resist rotation — anti-rotation core challenge.
4. Return handle to chest.'),
  ('dumbbell_deadlift', 'Dumbbell Deadlift', 'back', array['legs','glutes']::muscle_group[], 'dumbbell', 'hinge', false, 150, '1. Stand with dumbbells at sides, feet hip-width.
2. Hinge at hips, lowering dumbbells along legs to mid-shin.
3. Keep chest up and neutral spine.
4. Drive hips forward to stand.'),
  ('trap_bar_deadlift', 'Trap Bar Deadlift', 'legs', array['back','glutes']::muscle_group[], 'barbell', 'hinge', false, 210, '1. Step into trap bar, hip-width stance, grip handles.
2. Hinge to handles with flat back, hips above knees.
3. Drive floor away, rising with hips and shoulders simultaneously.
4. Lock out at top with full hip extension.'),
  ('decline_crunch', 'Decline Crunch', 'core', '{}'::muscle_group[], 'bodyweight', null, false, 60, '1. Hook feet on decline bench, cross arms over chest.
2. Lower torso fully.
3. Curl up, bringing ribs to hips.
4. Lower with control.'),
  ('dumbbell_floor_press', 'Dumbbell Floor Press', 'chest', array['triceps']::muscle_group[], 'dumbbell', 'push_horizontal', false, 120, '1. Sit on floor with dumbbells on thighs, lean back into floor.
2. Press dumbbells to lockout from the natural floor position.
3. Lower until triceps touch floor, pause briefly.
4. Press again.'),
  ('neutral_grip_pull_up', 'Neutral Grip Pull-Up', 'back', array['biceps']::muscle_group[], 'bodyweight', 'pull_vertical', false, 120, '1. Hang from parallel handles with palms facing each other.
2. Pull chest to handles.
3. Feel lats and biceps.
4. Lower to full hang.'),
  ('dumbbell_romanian_deadlift', 'Dumbbell Romanian Deadlift', 'back', array['glutes','legs']::muscle_group[], 'dumbbell', 'hinge', false, 150, '1. Hold dumbbells in front of thighs, hip-width stance.
2. Hinge at hips, lowering dumbbells along legs.
3. Feel hamstrings stretch fully.
4. Drive hips forward to return.'),
  ('ez_bar_curl', 'EZ Bar Curl', 'biceps', '{}'::muscle_group[], 'barbell', null, false, 90, '1. Hold EZ bar with angled grip (slightly supinated).
2. Pin elbows to sides, curl bar to shoulders.
3. Squeeze at top.
4. Lower with control.'),
  ('decline_bench_press_dumbbell', 'Decline Dumbbell Bench Press', 'chest', array['triceps']::muscle_group[], 'dumbbell', 'push_horizontal', false, 150, '1. Set bench to decline, kick dumbbells to chest.
2. Press up to lockout with palms forward.
3. Lower with control until elbows reach bench level.
4. Drive back to lockout, lower chest muscles contract.'),
  ('seated_row_machine', 'Seated Row Machine', 'back', array['biceps']::muscle_group[], 'machine', 'pull_horizontal', false, 90, '1. Set up with proper form for this exercise.
2. Execute the movement through full range of motion.
3. Control both the concentric and eccentric phases.
4. Rest as prescribed between sets.'),
  ('lateral_band_walk', 'Lateral Band Walk', 'glutes', array['legs']::muscle_group[], 'resistance_band', null, false, 60, '1. Loop resistance band above ankles.
2. Bend knees slightly, take side steps maintaining tension.
3. Keep feet shoulder-width apart throughout.
4. Step 15-20 reps each direction.'),
  ('windshield_wiper', 'Windshield Wiper', 'core', '{}'::muscle_group[], 'bodyweight', null, false, 60, '1. Hang from bar, raise legs to vertical.
2. Rotate legs side to side like windshield wipers.
3. Control the movement — no momentum.
4. Feel obliques work hard.'),
  ('sled_push', 'Sled Push', 'legs', array['glutes','cardio']::muscle_group[], 'none', 'carry', false, 120, '1. Load sled to desired weight, lean into vertical handles.
2. Drive forward with powerful leg pushes.
3. Keep back flat and head neutral.
4. Push for prescribed distance.'),
  ('kettlebell_clean', 'Kettlebell Clean', 'shoulders', array['legs','back']::muscle_group[], 'kettlebell', 'hinge', true, 120, '1. Hinge with one-hand grip.
2. Drive hips, pull bell into rack position.
3. Bell spirals around forearm.
4. Lower back to start.'),
  ('kettlebell_snatch', 'Kettlebell Snatch', 'shoulders', array['back','legs','core']::muscle_group[], 'kettlebell', 'hinge', true, 150, '1. Swing bell with one hand.
2. At the top, punch hand through bell handle.
3. Lock out bell overhead in one fluid motion.
4. Drop and repeat.'),
  ('leg_raise_lying', 'Lying Leg Raise', 'core', '{}'::muscle_group[], 'bodyweight', null, false, 60, '1. Lie flat on floor or bench, hands under lower back.
2. Raise legs to vertical, then lower to just above floor.
3. Keep lower back pressed to floor.
4. Squeeze abs throughout.'),
  ('romanian_deadlift_dumbbell_single', 'Single Leg Dumbbell Deadlift', 'glutes', array['legs','back']::muscle_group[], 'dumbbell', 'hinge', true, 120, '1. Stand on one leg, hold dumbbell in opposite hand.
2. Hinge at hip, lowering dumbbell toward foot.
3. Keep back flat, balance on standing leg.
4. Drive hip forward to return to standing.'),
  ('decline_cable_fly', 'Decline Cable Fly', 'chest', '{}'::muscle_group[], 'cable', 'push_horizontal', false, 75, '1. Adjust machine/cable to chest height.
2. Press or fly handles forward.
3. Squeeze chest at full extension.
4. Return with control.'),
  ('hollow_body_hold', 'Hollow Body Hold', 'core', '{}'::muscle_group[], 'bodyweight', null, false, 60, '1. Lie on back, press lower back to floor.
2. Raise arms overhead and legs just above floor.
3. Hold position maintaining lumbar contact with floor.
4. Breathe normally, progress with longer holds.'),
  ('cable_lateral_raise_standing', 'Cable Lateral Raise (Standing)', 'shoulders', '{}'::muscle_group[], 'cable', null, true, 60, '1. Set cable at ankle height, stand to one side.
2. Raise arm across body and up to shoulder height.
3. Hold at top.
4. Lower slowly.'),
  ('cable_lateral_raise_behind_back', 'Cable Lateral Raise (Behind Back)', 'shoulders', '{}'::muscle_group[], 'cable', null, true, 60, '1. Set low cable behind your back.
2. Raise arm directly out to side to shoulder height.
3. Squeeze medial deltoid at top.
4. Lower with control.'),
  ('cable_front_raise', 'Cable Front Raise', 'shoulders', '{}'::muscle_group[], 'cable', null, false, 60, '1. Set low pulley, stand facing away from stack.
2. Hold handle behind thigh.
3. Raise arm forward to shoulder height.
4. Lower with control.'),
  ('cable_front_raise_single', 'Cable Front Raise (Single Arm)', 'shoulders', '{}'::muscle_group[], 'cable', null, true, 60, '1. Set low pulley, stand sideways.
2. Raise one arm forward to shoulder height with cable resistance.
3. Pause at top.
4. Lower with control.'),
  ('cable_rear_delt_fly', 'Cable Rear Delt Fly', 'shoulders', array['back']::muscle_group[], 'cable', null, false, 60, '1. Set single cable at shoulder height.
2. Stand perpendicular to stack, arm across body.
3. Pull cable backward and to side, extending arm.
4. Squeeze rear delt, return.'),
  ('cable_upright_row', 'Cable Upright Row', 'shoulders', array['biceps','back']::muscle_group[], 'cable', null, false, 75, '1. Attach rope or bar to low pulley.
2. Stand back, grip handle(s), pull up along body to chin.
3. Elbows rise above wrists.
4. Lower slowly.'),
  ('cable_crossover_high', 'Cable Crossover (High)', 'chest', '{}'::muscle_group[], 'cable', null, false, 60, '1. Set pulleys at highest position.
2. Stand between towers, reach for handles with arms high.
3. Pull handles down and together to waist.
4. Squeeze chest hard at bottom, return slowly.'),
  ('cable_crossover_mid', 'Cable Crossover (Mid)', 'chest', '{}'::muscle_group[], 'cable', null, false, 60, '1. Set pulleys at shoulder height.
2. Step forward in split stance between towers.
3. Bring handles together in front of chest in a hugging arc.
4. Hold squeeze 1 second, return with control.'),
  ('cable_reverse_fly', 'Cable Reverse Fly', 'shoulders', array['back']::muscle_group[], 'cable', null, false, 60, '1. Set cables at chest height, one in each hand crossed.
2. Pull handles apart and back, squeezing rear delts.
3. Hold at peak.
4. Return with control.'),
  ('triceps_rope_pushdown', 'Triceps Rope Pushdown', 'triceps', '{}'::muscle_group[], 'cable', null, false, 75, '1. Attach rope to high cable, grip ends.
2. Pin elbows to sides, push rope down and separate hands at bottom.
3. Squeeze triceps at lockout.
4. Return with control.'),
  ('triceps_vbar_pushdown', 'Triceps V-Bar Pushdown', 'triceps', '{}'::muscle_group[], 'cable', null, false, 75, '1. Attach V-bar to high cable.
2. Pin elbows to sides, press down to lockout.
3. Squeeze at bottom.
4. Return slowly.'),
  ('triceps_reverse_grip_pushdown', 'Triceps Reverse Grip Pushdown', 'triceps', '{}'::muscle_group[], 'cable', null, false, 75, '1. Attach bar to high cable, grip underhand.
2. Pin elbows to sides, press down to lockout.
3. Targets medial and lateral heads.
4. Return with control.'),
  ('triceps_single_arm_pushdown', 'Triceps Single Arm Pushdown', 'triceps', '{}'::muscle_group[], 'cable', null, true, 60, '1. Attach single handle to high cable.
2. Pin elbow to side, press down to lockout.
3. Squeeze at bottom.
4. Return with control.'),
  ('overhead_rope_extension', 'Overhead Rope Extension', 'triceps', '{}'::muscle_group[], 'cable', null, false, 75, '1. Attach rope to high cable, turn away from stack.
2. Hold rope overhead, elbows pointing up.
3. Extend arms overhead to lockout.
4. Return, feel long head stretch.'),
  ('overhead_bar_extension_cable', 'Overhead Bar Extension (Cable)', 'triceps', '{}'::muscle_group[], 'cable', null, false, 75, '1. Attach bar to high cable, turn away from stack.
2. Hold bar overhead, elbows pointing forward.
3. Extend to full lockout overhead.
4. Return with control.'),
  ('cable_rope_curl', 'Cable Rope Curl', 'biceps', '{}'::muscle_group[], 'cable', null, false, 75, '1. Attach rope to low pulley, hold ends with neutral grip.
2. Curl rope upward, separating hands at top.
3. Squeeze biceps peak.
4. Return with control.'),
  ('cable_bar_curl', 'Cable Bar Curl', 'biceps', '{}'::muscle_group[], 'cable', null, false, 75, '1. Attach straight bar to low pulley, stand with supinated grip.
2. Curl bar to shoulders, elbows pinned.
3. Squeeze hard at top.
4. Lower with control.'),
  ('cable_reverse_curl', 'Cable Reverse Curl', 'biceps', '{}'::muscle_group[], 'cable', null, false, 75, '1. Attach bar to low pulley, grip overhand.
2. Curl with pronated grip, elbows pinned.
3. Targets brachialis and brachioradialis.
4. Lower with control.'),
  ('cable_hammer_curl', 'Cable Hammer Curl', 'biceps', '{}'::muscle_group[], 'cable', null, false, 75, '1. Attach rope to low cable, hold with neutral grip.
2. Curl rope to shoulders without rotating wrists.
3. Squeeze brachialis and brachioradialis.
4. Return with control.'),
  ('high_cable_curl', 'High Cable Curl', 'biceps', '{}'::muscle_group[], 'cable', null, false, 75, '1. Set cable above head, hold handle with one or two hands.
2. Curl from overhead position toward head.
3. Flex biceps at peak.
4. Return to overhead stretch.'),
  ('lat_pulldown_close_grip', 'Lat Pulldown (Close Grip)', 'back', array['biceps']::muscle_group[], 'cable', null, false, 90, '1. Attach close-grip bar, sit with thighs under pad.
2. Lean back slightly, pull bar to upper chest.
3. Squeeze lats at bottom.
4. Return, allowing full lat stretch.'),
  ('lat_pulldown_reverse_grip', 'Lat Pulldown (Reverse Grip)', 'back', array['biceps']::muscle_group[], 'cable', null, false, 90, '1. Grip bar underhand (supinated) shoulder-width.
2. Lean back slightly, pull to upper chest.
3. Feel biceps and lats working together.
4. Return with control.'),
  ('lat_pulldown_single_arm', 'Lat Pulldown (Single Arm)', 'back', array['biceps']::muscle_group[], 'cable', null, true, 75, '1. Attach single handle to high pulley.
2. Grip with one hand, sit or kneel.
3. Pull handle to shoulder, elbow driving down.
4. Return with control, rotate slightly.'),
  ('lat_pulldown_vbar', 'Lat Pulldown (V-Bar)', 'back', array['biceps']::muscle_group[], 'cable', null, false, 90, '1. Attach V-bar to high pulley, grip neutral (palms facing each other).
2. Lean back slightly, pull bar to upper chest.
3. Squeeze lats, elbows pointing down.
4. Return fully.'),
  ('lat_pulldown_neutral_grip', 'Lat Pulldown (Neutral Grip)', 'back', array['biceps']::muscle_group[], 'cable', null, false, 90, '1. Use wide neutral-grip bar, sit with thighs under pads.
2. Pull bar to upper chest with palms facing each other.
3. Squeeze lats and upper back.
4. Return to full stretch.'),
  ('seated_cable_row_wide', 'Seated Cable Row (Wide Bar)', 'back', array['biceps']::muscle_group[], 'cable', null, false, 90, '1. Attach wide bar to low cable, sit with feet braced.
2. Grip handles wide, sit tall.
3. Row to abdomen, flaring elbows slightly outward.
4. Return and let shoulders protract fully.'),
  ('cable_standing_crunch', 'Cable Standing Crunch', 'core', '{}'::muscle_group[], 'cable', null, false, 60, '1. Set cable above head, hold handle or rope.
2. Stand and crunch downward, flexing spine.
3. Squeeze abs at bottom.
4. Return slowly.'),
  ('incline_dumbbell_fly', 'Incline Dumbbell Fly', 'chest', array['shoulders']::muscle_group[], 'dumbbell', null, false, 90, '1. Set bench to 30-45°, press dumbbells to lockout.
2. Lower in a wide fly arc to upper-arm parallel with floor.
3. Feel upper-chest stretch at bottom.
4. Squeeze back to start.'),
  ('decline_dumbbell_fly', 'Decline Dumbbell Fly', 'chest', '{}'::muscle_group[], 'dumbbell', null, false, 90, '1. Set bench to decline, kick dumbbells up to lockout.
2. Lower in wide arc until arms are parallel with floor.
3. Feel lower chest stretch.
4. Squeeze dumbbells back together over chest.'),
  ('dumbbell_shrug_standing', 'Dumbbell Shrug (Standing)', 'back', '{}'::muscle_group[], 'dumbbell', null, false, 60, '1. Set up with proper form for this exercise.
2. Execute the movement through full range of motion.
3. Control both the concentric and eccentric phases.
4. Rest as prescribed between sets.'),
  ('dumbbell_overhead_press_standing', 'Dumbbell Overhead Press (Standing)', 'shoulders', array['triceps']::muscle_group[], 'dumbbell', null, false, 120, '1. Stand with dumbbells at shoulders, core braced.
2. Press dumbbells overhead to lockout.
3. Touch or nearly touch at top.
4. Lower with control.'),
  ('z_press_dumbbell', 'Z-Press (Dumbbell)', 'shoulders', array['triceps','core']::muscle_group[], 'dumbbell', null, false, 120, '1. Sit on floor with legs straight, dumbbells at shoulders.
2. Brace core, press dumbbells overhead.
3. Squeeze at lockout.
4. Lower with control.'),
  ('dumbbell_bent_over_row_two_arm', 'Dumbbell Bent Over Row (Two Arm)', 'back', array['biceps']::muscle_group[], 'dumbbell', null, false, 90, '1. Hinge to ~45° with a dumbbell in each hand.
2. Row both dumbbells to hips simultaneously.
3. Squeeze shoulder blades.
4. Lower fully.'),
  ('concentration_curl', 'Concentration Curl', 'biceps', '{}'::muscle_group[], 'dumbbell', null, true, 75, '1. Sit on bench, lean forward, brace elbow on inner thigh.
2. Curl dumbbell to shoulder.
3. Squeeze biceps hard at top.
4. Lower fully.'),
  ('cross_body_curl', 'Cross Body Curl', 'biceps', '{}'::muscle_group[], 'dumbbell', null, true, 75, '1. Hold dumbbell with hammer grip, stand tall.
2. Curl dumbbell across body toward opposite shoulder.
3. Squeeze at top.
4. Lower under control.'),
  ('overhead_dumbbell_extension_single', 'Single Arm Overhead Dumbbell Extension', 'triceps', '{}'::muscle_group[], 'dumbbell', null, true, 75, '1. Grip weight with overhand grip.
2. Extend elbows to full lockout.
3. Squeeze triceps at lockout.
4. Return with control.'),
  ('overhead_dumbbell_extension_two_arm', 'Overhead Dumbbell Extension (Two Arm)', 'triceps', '{}'::muscle_group[], 'dumbbell', null, false, 75, '1. Grip weight with overhand grip.
2. Extend elbows to full lockout.
3. Squeeze triceps at lockout.
4. Return with control.'),
  ('dumbbell_lying_triceps_extension', 'Dumbbell Lying Triceps Extension', 'triceps', '{}'::muscle_group[], 'dumbbell', null, false, 75, '1. Lie on bench, dumbbells overhead.
2. Lower toward head by bending elbows.
3. Keep upper arms vertical and elbows narrow.
4. Extend to lockout.'),
  ('goblet_lunge', 'Goblet Lunge', 'legs', array['glutes']::muscle_group[], 'dumbbell', null, true, 90, '1. Hold kettlebell or dumbbell at chest, step forward.
2. Lower back knee toward floor.
3. Drive front heel to return.
4. Alternate sides.'),
  ('lunge_dumbbell_walking', 'Dumbbell Walking Lunge', 'legs', array['glutes']::muscle_group[], 'dumbbell', null, true, 90, '1. Hold dumbbells at sides, step forward into lunge.
2. Lower back knee, then drive and step forward into next lunge.
3. Walk forward alternating legs.
4. Keep chest up throughout.'),
  ('lunge_dumbbell_stationary', 'Dumbbell Stationary Lunge', 'legs', array['glutes']::muscle_group[], 'dumbbell', null, true, 90, '1. Split stance with dumbbell in each hand.
2. Lower back knee toward floor.
3. Drive front heel to return.
4. Complete reps on one side, then switch.'),
  ('lunge_dumbbell_reverse', 'Dumbbell Reverse Lunge', 'legs', array['glutes']::muscle_group[], 'dumbbell', null, true, 90, '1. Hold dumbbells at sides, step backward.
2. Lower back knee to near floor.
3. Drive front heel to return.
4. Alternate legs.'),
  ('curtsy_lunge_dumbbell', 'Curtsy Lunge (Dumbbell)', 'legs', array['glutes']::muscle_group[], 'dumbbell', null, true, 90, '1. Stand with dumbbells at sides.
2. Step one foot diagonally behind opposite leg (curtsy position).
3. Lower back knee toward floor.
4. Return and alternate.'),
  ('lateral_lunge_dumbbell', 'Lateral Lunge (Dumbbell)', 'legs', array['glutes']::muscle_group[], 'dumbbell', null, true, 90, '1. Stand with dumbbells at sides, feet together.
2. Step one foot wide to the side, hinge into that leg.
3. Push-off the lateral leg to return.
4. Alternate sides.'),
  ('dumbbell_sumo_deadlift', 'Dumbbell Sumo Deadlift', 'legs', array['glutes','back']::muscle_group[], 'dumbbell', null, false, 120, '1. Set up with proper form for this exercise.
2. Execute the movement through full range of motion.
3. Control both the concentric and eccentric phases.
4. Rest as prescribed between sets.'),
  ('calf_raise_dumbbell_single', 'Calf Raise Single Leg (Dumbbell)', 'legs', '{}'::muscle_group[], 'dumbbell', null, true, 60, '1. Stand on one leg on edge of step, hold dumbbell same side.
2. Rise as high as possible on single foot.
3. Hold at top 1-2 seconds.
4. Lower heel below step edge.'),
  ('calf_raise_dumbbell_two', 'Calf Raise Two Leg (Dumbbell)', 'legs', '{}'::muscle_group[], 'dumbbell', null, false, 60, '1. Stand on edge of step with a dumbbell in each hand.
2. Rise high on both toes.
3. Hold at top 1-2 seconds.
4. Lower heels below step for full stretch.'),
  ('floor_press_barbell', 'Barbell Floor Press', 'chest', array['triceps']::muscle_group[], 'barbell', null, false, 150, '1. Lie on floor, bar over chest set on pins.
2. Grip shoulder-width, press to lockout.
3. Triceps touch floor between reps.
4. Re-engage and press again.'),
  ('board_press', 'Board Press', 'chest', array['triceps']::muscle_group[], 'barbell', null, false, 150, '1. Partner holds 1-3 boards on your chest, unrack bar.
2. Lower bar to boards (shorter range of motion).
3. Press explosively from shortened position.
4. Focus on lockout strength.'),
  ('spoto_press', 'Spoto Press', 'chest', array['triceps']::muscle_group[], 'barbell', null, false, 150, '1. Set up for bench press, unrack bar.
2. Lower bar and stop 1-2 inches above chest — no contact.
3. Hold 1 second, maintain tension throughout.
4. Press to lockout.'),
  ('push_press_barbell', 'Barbell Push Press', 'shoulders', array['triceps','legs']::muscle_group[], 'barbell', null, false, 150, '1. Bar at collarbone in front rack position.
2. Dip knees slightly, then drive hips and legs.
3. Use the leg drive to press bar overhead.
4. Lock out with bar over ears.'),
  ('push_jerk_barbell', 'Barbell Push Jerk', 'shoulders', array['triceps','legs']::muscle_group[], 'barbell', null, false, 150, '1. Bar at collarbone, dip and drive with legs.
2. Press bar overhead, then re-bend knees to catch bar in quarter squat.
3. Stand to lockout from caught position.
4. Lower bar to front rack.'),
  ('behind_neck_press', 'Behind The Neck Press', 'shoulders', array['triceps']::muscle_group[], 'barbell', null, false, 120, '1. Bar resting on upper traps behind head, wide grip.
2. Press bar straight overhead.
3. Lower bar behind head to level of ears — not neck.
4. Requires excellent shoulder mobility.'),
  ('z_press_barbell', 'Z-Press (Barbell)', 'shoulders', array['triceps','core']::muscle_group[], 'barbell', null, false, 150, '1. Sit on floor with legs straight, bar in front rack.
2. Brace core hard, press bar overhead from seated position.
3. Lock out with bar over head.
4. Lower to front rack.'),
  ('rack_pull_knee', 'Rack Pull (From Knee)', 'back', array['glutes','legs']::muscle_group[], 'barbell', null, false, 180, '1. Hinge to rowing position, flat back.
2. Row bar to abdomen, elbows back.
3. Squeeze shoulder blades at top.
4. Lower fully.'),
  ('snatch_grip_deadlift', 'Snatch Grip Deadlift', 'back', array['legs','glutes']::muscle_group[], 'barbell', null, false, 180, '1. Hinge to rowing position, flat back.
2. Row bar to abdomen, elbows back.
3. Squeeze shoulder blades at top.
4. Lower fully.'),
  ('front_squat_pause', 'Front Squat (Pause)', 'legs', array['glutes','core']::muscle_group[], 'barbell', null, false, 180, '1. Bar in front rack, feet shoulder-width.
2. Squat down to parallel, pause 2-3 seconds at bottom.
3. No bounce; maintain tension and upright torso.
4. Drive through heels to stand.'),
  ('back_squat_pause', 'Back Squat (Pause)', 'legs', array['glutes','core']::muscle_group[], 'barbell', null, false, 180, '1. Bar on upper back, squat to parallel.
2. Pause 2-3 seconds at bottom with full tension.
3. No bounce; stay tight.
4. Drive through heels to stand.'),
  ('high_bar_squat', 'High Bar Back Squat', 'legs', array['glutes','core']::muscle_group[], 'barbell', null, false, 180, '1. Bar resting on traps (higher position), more upright torso.
2. Squat to parallel with knees tracking over toes.
3. Vertical shin preferred.
4. Drive through heels.'),
  ('low_bar_squat', 'Low Bar Back Squat', 'legs', array['glutes','core']::muscle_group[], 'barbell', null, false, 180, '1. Bar positioned on rear deltoids (lower), slight forward lean.
2. Squat to parallel, hips push back.
3. Drives posterior chain hard.
4. Push through heels.'),
  ('safety_bar_squat', 'Safety Bar Squat', 'legs', array['glutes','core']::muscle_group[], 'barbell', null, false, 180, '1. Camber bar rests on safety handles, grip handles in front.
2. More upright torso possible with forward-handle bar.
3. Squat to parallel.
4. Drive through heels.'),
  ('hack_squat_barbell', 'Hack Squat (Barbell)', 'legs', array['glutes']::muscle_group[], 'barbell', null, false, 150, '1. Stand with barbell behind legs at calves.
2. Hinge and grip bar, then drive to standing (heels may rise).
3. Targets quadriceps.
4. Lower bar with control.'),
  ('good_morning_seated', 'Seated Good Morning', 'back', array['legs','glutes']::muscle_group[], 'barbell', null, false, 120, '1. Sit on bench, bar on upper back.
2. Hinge forward at hips, lowering chest toward thighs.
3. Keep back flat, feel erectors and hamstrings stretch.
4. Drive back upright using back extensors.'),
  ('bent_over_row_supinated', 'Bent Over Row (Supinated)', 'back', array['biceps']::muscle_group[], 'barbell', null, false, 120, '1. Hinge to rowing position, flat back.
2. Row bar to abdomen, elbows back.
3. Squeeze shoulder blades at top.
4. Lower fully.'),
  ('yates_row', 'Yates Row', 'back', array['biceps']::muscle_group[], 'barbell', null, false, 120, '1. Stand more upright than standard row (~30° lean), underhand grip.
2. Row bar to lower abdomen.
3. Squeeze lats and mid-back.
4. Lower with control.'),
  ('meadows_row', 'Meadows Row', 'back', array['biceps']::muscle_group[], 'barbell', null, true, 90, '1. Stand perpendicular to landmine, grip the collar end with one hand.
2. Hinge to about 45°, foot staggered.
3. Row bar explosively to hip, elbow high.
4. Lower fully.'),
  ('t_bar_row_landmine', 'T-Bar Row (Landmine)', 'back', array['biceps']::muscle_group[], 'barbell', null, false, 120, '1. Load one end of barbell into landmine or corner.
2. Stand over bar with handles or V-bar attachment.
3. Row to chest with chest nearly parallel to floor.
4. Lower fully.'),
  ('landmine_squat_to_press', 'Landmine Squat to Press', 'shoulders', array['legs','core']::muscle_group[], 'barbell', null, false, 120, '1. Hold bar in front-rack, feet shoulder-width.
2. Squat to parallel.
3. Drive up and transition to overhead press as you stand.
4. Lower bar to front-rack.'),
  ('pull_up_wide', 'Wide Grip Pull-Up', 'back', array['biceps']::muscle_group[], 'bodyweight', null, false, 120, '1. Grip bar much wider than shoulder-width, palms forward.
2. Pull until chin clears bar or chest reaches bar.
3. Squeeze upper-back width.
4. Lower under control.'),
  ('pull_up_close', 'Close Grip Pull-Up', 'back', array['biceps']::muscle_group[], 'bodyweight', null, false, 120, '1. Grip bar with hands close together, palms forward or neutral.
2. Pull elbows down and in, bringing chest to bar.
3. Full biceps and lat engagement.
4. Lower slowly.'),
  ('l_sit_pull_up', 'L-Sit Pull-Up', 'back', array['biceps','core']::muscle_group[], 'bodyweight', null, false, 120, '1. Hang from bar, legs raised to horizontal.
2. Maintain leg position and perform pull-up.
3. Full range of motion.
4. Lower with control.'),
  ('commando_pull_up', 'Commando Pull-Up', 'back', array['biceps']::muscle_group[], 'bodyweight', null, false, 120, '1. Grip bar with one hand in front of the other (ladder-style), palms opposite.
2. Pull chin to one side of bar.
3. Lower and pull to the other side alternating.
4. Control descent each rep.'),
  ('push_up_decline', 'Decline Push-Up', 'chest', array['triceps','shoulders']::muscle_group[], 'bodyweight', null, false, 60, '1. Place feet on an elevated surface, hands on floor shoulder-width apart.
2. Body straight from feet to head.
3. Lower chest toward floor with elbows at ~45°.
4. Press back to start.'),
  ('push_up_incline', 'Incline Push-Up', 'chest', array['triceps','shoulders']::muscle_group[], 'bodyweight', null, false, 60, '1. Place hands on an elevated surface (bench or bar), feet on floor.
2. Body forms a straight line.
3. Lower chest toward the elevated surface.
4. Press back to lockout.'),
  ('push_up_archer', 'Archer Push-Up', 'chest', array['triceps']::muscle_group[], 'bodyweight', null, true, 90, '1. Start in wide push-up stance.
2. Shift weight to one arm as you lower, other arm straightens.
3. Press back to center with the loaded arm.
4. Alternate sides.'),
  ('push_up_clap', 'Clap Push-Up', 'chest', array['triceps']::muscle_group[], 'bodyweight', null, false, 90, '1. Start in standard push-up position.
2. Lower quickly then press explosively enough to leave the ground.
3. Clap hands, land with bent elbows to absorb impact.
4. Reset and repeat.'),
  ('handstand_push_up', 'Handstand Push-Up', 'shoulders', array['triceps']::muscle_group[], 'bodyweight', null, false, 120, '1. Kick into handstand against wall, hands shoulder-width.
2. Lower head toward floor by bending elbows.
3. Press back to lockout.
4. Maintain body tension.'),
  ('pseudo_planche_push_up', 'Pseudo Planche Push-Up', 'chest', array['shoulders','triceps']::muscle_group[], 'bodyweight', null, false, 90, '1. Place hands at waist level (behind hips), lean forward.
2. Lower by bending elbows, keeping forward lean.
3. Press back to start.
4. Trains planche strength.'),
  ('push_up_wide', 'Wide Push-Up', 'chest', array['shoulders']::muscle_group[], 'bodyweight', null, false, 60, '1. Place hands wider than shoulder-width, body straight.
2. Lower chest to floor with elbows flaring wide.
3. Feel deeper chest stretch.
4. Press back to lockout.'),
  ('dip_bench', 'Bench Dip', 'triceps', array['chest','shoulders']::muscle_group[], 'bodyweight', null, false, 75, '1. Grip edge of bench, legs extended or bent.
2. Lower hips by bending elbows to 90°.
3. Press back to lockout.
4. Easier than parallel bar dips.'),
  ('ring_dip', 'Ring Dip', 'chest', array['triceps','shoulders']::muscle_group[], 'bodyweight', null, false, 120, '1. Support on gymnastics rings, arms locked.
2. Lower until upper arms are parallel with floor, turning rings out slightly.
3. Press back to lockout.
4. Rings turned out increases stability.'),
  ('bar_muscle_up', 'Bar Muscle-Up', 'back', array['chest','triceps','biceps']::muscle_group[], 'bodyweight', null, false, 120, '1. Hang from pull-up bar.
2. Explosive pull, then transition with a false grip.
3. Press to lockout above the bar.
4. Lower to hang.'),
  ('ring_muscle_up', 'Ring Muscle-Up', 'back', array['chest','triceps','biceps']::muscle_group[], 'bodyweight', null, false, 120, '1. Hang from gymnastics rings, false grip.
2. Pull explosively and transition rings to waist.
3. Dip to lockout, turning rings out at top.
4. Lower with control.'),
  ('plank_high', 'High Plank', 'core', array['shoulders']::muscle_group[], 'bodyweight', null, false, 60, '1. Hands on floor under shoulders (push-up top position).
2. Body straight from head to heels.
3. Squeeze core, glutes, and quads.
4. Hold for prescribed time.'),
  ('plank_reverse', 'Reverse Plank', 'core', array['glutes','back']::muscle_group[], 'bodyweight', null, false, 60, '1. Sit on floor, hands behind you under shoulders.
2. Press hips up into reverse plank.
3. Body straight from head to heels.
4. Squeeze glutes and core.'),
  ('plank_walking', 'Walking Plank', 'core', array['shoulders']::muscle_group[], 'bodyweight', null, false, 60, '1. Start in forearm plank.
2. Press up to hands one arm at a time.
3. Lower back to forearms one arm at a time.
4. Alternate leading arm.'),
  ('plank_leg_lift', 'Plank with Leg Lift', 'core', array['glutes']::muscle_group[], 'bodyweight', null, true, 60, '1. Hold forearm plank position.
2. Lift one leg off floor, hold 2-3 seconds.
3. Lower and alternate.
4. Keep hips level throughout.'),
  ('rkc_plank', 'RKC Plank', 'core', '{}'::muscle_group[], 'bodyweight', null, false, 60, '1. Forearm plank, maximize full-body tension.
2. Pull elbows toward toes and toes toward elbows.
3. Maximum isometric contraction throughout.
4. Hold for 10-30 seconds.'),
  ('l_sit', 'L-Sit', 'core', array['triceps','shoulders']::muscle_group[], 'bodyweight', null, false, 90, '1. Support weight on parallel bars or floor, arms locked.
2. Raise legs to horizontal, feet together.
3. Hold with maximum tension in abs and hip flexors.
4. Progress by holding longer or elevating legs.'),
  ('v_sit', 'V-Sit', 'core', '{}'::muscle_group[], 'bodyweight', null, false, 90, '1. Sit balancing on tailbone, legs and torso both at 45°.
2. Arms parallel to floor.
3. Hold with tight core and hip flexors.
4. Progress to longer holds.'),
  ('tuck_planche', 'Tuck Planche', 'shoulders', array['chest','core']::muscle_group[], 'bodyweight', null, false, 120, '1. Support on hands with arms straight.
2. Lean forward shifting center over hands.
3. Bring knees to chest, feet off floor.
4. Hold. Progress to longer holds and more extended body.'),
  ('pistol_squat', 'Pistol Squat', 'legs', array['glutes','core']::muscle_group[], 'bodyweight', null, true, 90, '1. Stand on one leg, other leg extended forward.
2. Lower on one leg to full depth.
3. Drive through heel to stand.
4. Keep arms out or counterbalance as needed.'),
  ('assisted_pistol_squat', 'Assisted Pistol Squat', 'legs', array['glutes']::muscle_group[], 'bodyweight', null, true, 90, '1. Hold TRX or pole for balance.
2. Lower on one leg to near-full depth.
3. Use minimal assistance from handles.
4. Drive through heel to stand.'),
  ('shrimp_squat', 'Shrimp Squat', 'legs', array['glutes']::muscle_group[], 'bodyweight', null, true, 90, '1. Stand on one leg, grab opposite foot behind back.
2. Lower into single-leg squat, rear knee toward floor.
3. Keep chest tall.
4. Drive through standing heel.'),
  ('bulgarian_split_squat_bodyweight', 'Bulgarian Split Squat (Bodyweight)', 'legs', array['glutes']::muscle_group[], 'bodyweight', null, true, 90, '1. Rear foot on bench, front foot forward, bodyweight only.
2. Lower back knee toward floor.
3. Drive front heel.
4. Complete reps each side.'),
  ('single_leg_rdl_bodyweight', 'Single Leg Romanian Deadlift (Bodyweight)', 'legs', array['glutes','core']::muscle_group[], 'bodyweight', null, true, 90, '1. Stand on one leg, no weight.
2. Hinge at hip, free leg rises behind.
3. Maintain neutral spine.
4. Return by driving the standing hip forward.'),
  ('nordic_curl', 'Nordic Curl', 'legs', '{}'::muscle_group[], 'bodyweight', null, false, 120, '1. Secure ankles, kneel with body upright.
2. Slowly lower torso toward floor, hamstrings resisting.
3. Use hands to break fall at bottom.
4. Curl hamstrings to return to start.'),
  ('nordic_curl_negative', 'Nordic Curl (Negative)', 'legs', '{}'::muscle_group[], 'bodyweight', null, false, 120, '1. Secure ankles, kneel upright.
2. Slowly lower to floor as slowly as possible.
3. Push off floor and return to start.
4. Focus on maximum eccentric time under tension.'),
  ('reverse_nordic', 'Reverse Nordic', 'legs', '{}'::muscle_group[], 'bodyweight', null, false, 90, '1. Kneel, ankles held down.
2. Lean back slowly, extending hips and spine.
3. Quad stretch and hip-flexor load.
4. Return to upright.'),
  ('glute_bridge_single_leg', 'Glute Bridge (Single Leg)', 'glutes', array['legs']::muscle_group[], 'bodyweight', null, true, 60, '1. Lie on floor, one knee bent, other leg extended.
2. Drive single-leg hip thrust to full extension.
3. Squeeze glute at top.
4. Lower and repeat.'),
  ('glute_bridge_elevated', 'Elevated Glute Bridge', 'glutes', array['legs']::muscle_group[], 'bodyweight', null, false, 60, '1. Upper back on bench edge, feet on floor or box.
2. Drive hips up to full extension without weight.
3. Squeeze glutes at top.
4. Lower with control.'),
  ('hip_thrust_single_leg', 'Single Leg Hip Thrust', 'glutes', array['legs']::muscle_group[], 'bodyweight', null, true, 90, '1. Upper back on bench, one foot planted, other leg raised.
2. Drive single hip to full extension.
3. Squeeze glute at top.
4. Lower with control.'),
  ('scapular_pull_up', 'Scapular Pull-Up', 'back', '{}'::muscle_group[], 'bodyweight', null, false, 60, '1. Hang from bar in dead hang.
2. Without bending elbows, pull shoulder blades down and together.
3. Rise slightly through shoulder girdle only.
4. Return to full protraction/depression.'),
  ('toes_to_bar', 'Toes to Bar', 'core', array['back']::muscle_group[], 'bodyweight', null, false, 90, '1. Hang from bar, arms straight.
2. Raise legs and touch toes to bar.
3. Control descent, minimal swing.
4. Feel full core and hip flexor engagement.'),
  ('hanging_leg_raise_straight', 'Hanging Straight Leg Raise', 'core', '{}'::muscle_group[], 'bodyweight', null, false, 90, '1. Hang from bar, arms straight.
2. Raise legs with straight knees to horizontal or above.
3. Squeeze abs at top.
4. Lower with control, no swinging.'),
  ('leg_press_machine', '45° Leg Press', 'legs', array['glutes']::muscle_group[], 'machine', null, false, 150, '1. Load platform, sit with feet shoulder-width.
2. Unlock safeties, lower to 90°.
3. Press back to near-lockout.
4. Control descent.'),
  ('leg_press_horizontal', 'Horizontal Leg Press', 'legs', array['glutes']::muscle_group[], 'machine', null, false, 150, '1. Sit in horizontal leg press machine, feet on platform.
2. Lower by bending knees toward chest.
3. Press through heels to near-lockout.
4. Control descent.'),
  ('hack_squat_machine', 'Hack Squat Machine', 'legs', array['glutes']::muscle_group[], 'machine', null, false, 150, '1. Set shoulders under pads, feet high on platform for glute focus.
2. Unlock and lower to ~90° at knee.
3. Press through heels to near-lockout.
4. Control every rep.'),
  ('leg_curl_standing', 'Leg Curl (Standing)', 'legs', '{}'::muscle_group[], 'machine', null, true, 90, '1. Stand in machine, one ankle hooked behind pad.
2. Curl heel toward glute.
3. Squeeze hamstring at peak.
4. Lower under control.'),
  ('calf_raise_seated_machine', 'Seated Calf Raise (Machine)', 'legs', '{}'::muscle_group[], 'machine', null, false, 60, '1. Sit in machine, thighs under pad, balls of feet on platform.
2. Rise on toes as high as possible.
3. Hold at top.
4. Lower heels for full Achilles stretch.'),
  ('calf_raise_donkey', 'Donkey Calf Raise', 'legs', '{}'::muscle_group[], 'machine', null, false, 60, '1. Bend forward at hips, forearms on support, feet on edge of platform.
2. Rise high on toes.
3. Hold 1 second at top.
4. Lower heels below platform for deep stretch.'),
  ('back_extension_45', 'Back Extension (45°)', 'back', array['glutes']::muscle_group[], 'machine', null, false, 90, '1. Lock ankles in 45° back extension machine, hinge forward.
2. Lower torso until roughly perpendicular to floor.
3. Extend back to horizontal using glutes and spinal erectors.
4. Do not hyperextend at top.'),
  ('back_extension_horizontal', 'Back Extension (Horizontal)', 'back', array['glutes']::muscle_group[], 'machine', null, false, 90, '1. Set machine to horizontal, secure ankles, start with torso down.
2. Raise torso to horizontal plane using back extensors.
3. Squeeze glutes at top.
4. Lower under control.'),
  ('ghd_back_extension', 'GHD Back Extension', 'back', array['glutes']::muscle_group[], 'machine', null, false, 90, '1. Set GHD so hip crease is at pad edge, feet secured.
2. Lower torso toward floor in controlled hip hinge.
3. Extend back to horizontal, squeezing glutes.
4. Do not hyperextend; hold 1 second at top.'),
  ('reverse_hyper', 'Reverse Hyperextension', 'glutes', array['back','legs']::muscle_group[], 'machine', null, false, 90, '1. Lie face-down on reverse hyper machine, grip handles.
2. Swing legs downward, then explosively drive hips to extension.
3. Legs rise behind you, squeezing glutes.
4. Control the swing back down.'),
  ('ab_crunch_machine', 'Ab Crunch Machine', 'core', '{}'::muscle_group[], 'machine', null, false, 60, '1. Sit in machine, adjust chest pad, grip handles.
2. Crunch forward by rounding spine.
3. Squeeze abs at full flexion.
4. Return slowly.'),
  ('rotary_torso_machine', 'Rotary Torso Machine', 'core', '{}'::muscle_group[], 'machine', null, false, 60, '1. Sit in machine, grip handles, set resistance.
2. Rotate torso to one side.
3. Return to center, then rotate to other side.
4. Targets obliques.'),
  ('assisted_pull_up_machine', 'Assisted Pull-Up Machine', 'back', array['biceps']::muscle_group[], 'machine', null, false, 90, '1. Set counterweight (higher = easier), kneel or stand on platform.
2. Pull bar down, bringing chest to bar.
3. Squeeze lats.
4. Lower with control.'),
  ('assisted_dip_machine', 'Assisted Dip Machine', 'triceps', array['chest']::muscle_group[], 'machine', null, false, 75, '1. Set counterweight, kneel on platform.
2. Lower until upper arms are parallel.
3. Press to lockout.
4. Control descent.'),
  ('smith_machine_row', 'Smith Machine Bent Over Row', 'back', array['biceps']::muscle_group[], 'machine', null, false, 120, '1. Set bar at hip height in Smith machine.
2. Hinge to row position, grip bar.
3. Row to abdomen.
4. Lower with control.'),
  ('smith_machine_split_squat', 'Smith Machine Split Squat', 'legs', array['glutes']::muscle_group[], 'machine', null, true, 120, '1. Set Smith machine bar on back, rear foot forward or static split.
2. Lower back knee toward floor.
3. Drive through front heel.
4. Control descent.'),
  ('glute_kickback_machine', 'Glute Kickback Machine', 'glutes', '{}'::muscle_group[], 'machine', null, true, 60, '1. Kneel in machine, pad behind knee of working leg.
2. Press leg back and up.
3. Squeeze glute at full extension.
4. Return with control.'),
  ('roman_chair_knee_raise', 'Roman Chair Knee Raise', 'core', '{}'::muscle_group[], 'machine', null, false, 60, '1. Set in Roman chair, back against pad, forearms on arms.
2. Hang legs straight, then raise knees to chest.
3. Control descent.
4. Targets hip flexors and lower core.'),
  ('hammer_strength_chest_press', 'Hammer Strength Chest Press', 'chest', array['triceps','shoulders']::muscle_group[], 'machine', null, false, 120, '1. Adjust seat so handles align with mid-chest.
2. Grip handles, retract shoulder blades.
3. Press handles forward to full extension.
4. Return slowly, getting full pectoral stretch.'),
  ('converging_chest_press_machine', 'Converging Chest Press Machine', 'chest', array['triceps']::muscle_group[], 'machine', null, false, 120, '1. Adjust seat, grip handles at chest level.
2. Press handles forward and inward (converging path).
3. Feel chest squeeze at full extension.
4. Return with control.'),
  ('chest_supported_row_machine', 'Chest Supported Row Machine', 'back', array['biceps']::muscle_group[], 'machine', null, false, 90, '1. Sit at machine, chest against pad, grip handles.
2. Row handles to chest.
3. Squeeze upper back at peak.
4. Return with control.'),
  ('overhead_carry', 'Overhead Carry', 'shoulders', array['core']::muscle_group[], 'dumbbell', null, false, 90, '1. Press weight overhead to lockout.
2. Walk for prescribed distance, keeping arm locked.
3. Core braced, no side-lean.
4. Switch sides.'),
  ('rack_carry', 'Rack Carry', 'core', array['shoulders']::muscle_group[], 'dumbbell', null, false, 90, '1. Hold weight in front-rack position at shoulder.
2. Walk upright for prescribed distance.
3. Keep elbow high to maintain rack.
4. Switch sides.'),
  ('kettlebell_swing_one_arm', 'Kettlebell Swing (One Hand)', 'glutes', array['back','core']::muscle_group[], 'kettlebell', null, true, 90, '1. Hinge with one-hand grip on bell between knees.
2. Drive hips explosively, letting bell float to chest height.
3. Hinge as bell descends.
4. All power from hips and glutes.'),
  ('kettlebell_swing_american', 'Kettlebell Swing (American)', 'glutes', array['shoulders','core']::muscle_group[], 'kettlebell', null, false, 90, '1. Two-hand grip, same swing as Russian but continue overhead.
2. Drive bell all the way to lockout above head.
3. Requires more shoulder mobility.
4. Control descent back through hips.'),
  ('kettlebell_clean_single', 'Kettlebell Clean (Single)', 'back', array['legs','core']::muscle_group[], 'kettlebell', null, true, 90, '1. Hold bell in one hand at hip hinge.
2. Drive hips and pull bell into rack position at shoulder.
3. Bell spirals around forearm into rack — no banging.
4. Lower back to swing position.'),
  ('kettlebell_clean_double', 'Kettlebell Clean (Double)', 'back', array['legs','core']::muscle_group[], 'kettlebell', null, false, 120, '1. Hold a bell in each hand at hip hinge.
2. Drive hips and clean both bells to double-rack simultaneously.
3. Bells spiral around forearms.
4. Lower both to swing position.'),
  ('kettlebell_press_double', 'Kettlebell Press (Double)', 'shoulders', array['triceps']::muscle_group[], 'kettlebell', null, false, 120, '1. Clean two bells to double-rack.
2. Press both overhead simultaneously.
3. Lock out, squeeze glutes for stability.
4. Lower to rack.'),
  ('kettlebell_press_bottom_up', 'Kettlebell Press (Bottom Up)', 'shoulders', array['core']::muscle_group[], 'kettlebell', null, true, 90, '1. Clean kettlebell to rack with bell inverted (bottom facing up).
2. Press carefully to lockout, bell still inverted.
3. Requires grip strength and stability.
4. Lower under control.'),
  ('kettlebell_snatch_double', 'Kettlebell Snatch (Double)', 'shoulders', array['back','core']::muscle_group[], 'kettlebell', null, false, 120, '1. Hold two bells with hip hinge.
2. Explosively extend hips, punch hands through bell handles.
3. Both bells lock out overhead simultaneously.
4. Drop to swing and repeat.'),
  ('kettlebell_halo', 'Kettlebell Halo', 'shoulders', array['core']::muscle_group[], 'kettlebell', null, false, 60, '1. Hold single bell by the horns at chest.
2. Circle bell around head, keeping elbows controlled.
3. Circle one direction for reps, then reverse.
4. Feel shoulder mobility and scapular work.'),
  ('kettlebell_windmill', 'Kettlebell Windmill', 'core', array['shoulders','back']::muscle_group[], 'kettlebell', null, true, 90, '1. Press bell overhead with one hand, feet wide.
2. Rotate torso, reaching opposite hand toward foot.
3. Keep bell locked overhead throughout.
4. Return to standing.'),
  ('couch_stretch', 'Couch Stretch', 'legs', '{}'::muscle_group[], 'bodyweight', null, true, 30, '1. Kneel with one shin against a wall or couch.
2. Lean back, bringing heel toward glute.
3. Open hip flexor of rear leg.
4. Hold 60-90 seconds per side.'),
  ('pigeon_pose', 'Pigeon Pose', 'glutes', array['legs']::muscle_group[], 'bodyweight', null, true, 30, '1. From downward-dog, bring one shin forward perpendicular to spine.
2. Lower hips to floor (or block for support).
3. Feel hip-external-rotation stretch.
4. Hold 60-120 seconds per side.'),
  ('ninety_ninety_stretch', '90/90 Hip Stretch', 'glutes', array['legs']::muscle_group[], 'bodyweight', null, true, 30, '1. Sit with both legs at 90° angles (one in front, one to the side).
2. Lean forward over front shin.
3. Feel hip-external rotation of front leg.
4. Switch sides; hold 60-90 seconds.'),
  ('deep_squat_hold', 'Deep Squat Hold', 'legs', array['core']::muscle_group[], 'bodyweight', null, false, 30, '1. Stand with feet shoulder-width, toes out slightly.
2. Squat fully to bottom position.
3. Hold with elbows pressing against inner knees.
4. Hold 30-60 seconds, breathing normally.'),
  ('wall_sit', 'Wall Sit', 'legs', '{}'::muscle_group[], 'bodyweight', null, false, 60, '1. Stand with back against wall, walk feet out.
2. Slide down until thighs are parallel to floor.
3. Hold with back flat against wall.
4. Hold for prescribed time.'),
  ('dead_bug_progression', 'Dead Bug Progression', 'core', '{}'::muscle_group[], 'bodyweight', null, false, 60, '1. Brace core maximally.
2. Perform the movement with full range.
3. Squeeze abs at peak.
4. Return with control.'),
  ('decline_barbell_bench_press_30', 'Decline Bench Press (30°)', 'chest', array['triceps']::muscle_group[], 'barbell', null, false, 150, '1. Set bench to -30° decline, bar on chest level.
2. Lower bar to lower chest.
3. Press to lockout.
4. Control every rep.'),
  ('incline_dumbbell_bench_30', 'Incline Dumbbell Bench Press (30°)', 'chest', array['triceps','shoulders']::muscle_group[], 'dumbbell', null, false, 120, '1. Set bench to 30°, kick dumbbells to chest and lie back.
2. Press up with palms forward.
3. Lower dumbbells until upper arms reach bench level.
4. Press back to lockout, focusing on upper-chest stretch at 30° angle.'),
  ('incline_dumbbell_bench_45', 'Incline Dumbbell Bench Press (45°)', 'chest', array['triceps','shoulders']::muscle_group[], 'dumbbell', null, false, 120, '1. Set bench to 45°, kick dumbbells to chest, lie back.
2. Press up with palms facing forward, elbows flared slightly.
3. Lower until upper arms are parallel with bench.
4. Drive through chest and shoulders to lockout.'),
  ('incline_dumbbell_bench_60', 'Incline Dumbbell Bench Press (60°)', 'chest', array['triceps','shoulders']::muscle_group[], 'dumbbell', null, false, 120, '1. Set bench to steep 60° incline (near shoulder-press angle).
2. Kick dumbbells to shoulders and press overhead.
3. Lower with control until elbows are at 90°.
4. Press back to lockout, emphasizing upper chest and front delts.'),
  ('romanian_deadlift_barbell', 'Romanian Deadlift (Barbell)', 'legs', array['glutes','back']::muscle_group[], 'barbell', null, false, 150, '1. Hold bar at hips, hinge back pushing hips rearward.
2. Bar stays close to thighs.
3. Lower to mid-shin, hamstrings loaded.
4. Drive hips forward to stand.'),
  ('stiff_leg_deadlift_barbell', 'Stiff Leg Deadlift (Barbell)', 'legs', array['glutes','back']::muscle_group[], 'barbell', null, false, 150, '1. Stand tall, slight knee bend, grip bar shoulder-width.
2. Hinge keeping legs straight, bar close to shins.
3. Feel hamstring stretch.
4. Return by extending hips.'),
  ('straight_arm_pulldown_rope', 'Straight Arm Pulldown (Rope)', 'back', array['triceps']::muscle_group[], 'cable', null, false, 75, '1. Attach rope to high cable, stand with nearly straight arms.
2. Pull rope down to hips.
3. Squeeze lats at bottom.
4. Return under control.'),
  ('cable_row_single_arm_high', 'High Cable Row (Single Arm)', 'back', array['biceps']::muscle_group[], 'cable', null, true, 75, '1. Set cable at head height, pull handle with one hand.
2. Step back, split stance, brace core.
3. Row handle down and toward hip.
4. Return under control.'),
  ('db_preacher_curl', 'Dumbbell Preacher Curl', 'biceps', '{}'::muscle_group[], 'dumbbell', null, true, 75, '1. Set on preacher bench, upper arm on pad, dumbbell in hand.
2. Curl dumbbell to shoulder.
3. Squeeze at top.
4. Lower to full stretch.'),
  ('ez_bar_preacher_curl', 'EZ Bar Preacher Curl', 'biceps', '{}'::muscle_group[], 'barbell', null, false, 75, '1. Grip EZ bar with inner angled handles at preacher bench.
2. Curl bar to shoulders, elbows on pad.
3. Squeeze at top.
4. Lower fully for deep stretch.'),
  ('ez_bar_skull_crusher', 'EZ Bar Skull Crusher', 'triceps', '{}'::muscle_group[], 'barbell', null, false, 90, '1. Lie on bench, grip EZ bar inner handles.
2. Lower bar toward forehead by bending elbows.
3. Keep elbows stationary, feel stretch.
4. Extend to lockout.'),
  ('incline_hammer_curl', 'Incline Hammer Curl', 'biceps', '{}'::muscle_group[], 'dumbbell', null, true, 75, '1. Sit on incline bench, arms hanging with neutral grip.
2. Curl dumbbells without wrist rotation.
3. Feel stretched brachialis and long head.
4. Lower fully.'),
  ('cable_face_pull_single', 'Cable Face Pull (Single Arm)', 'shoulders', array['back']::muscle_group[], 'cable', null, true, 60, '1. Set single cable at eye level, pull with one hand to face.
2. Elbow high, externally rotate at end.
3. Pause at peak.
4. Return with control.'),
  ('seated_cable_row_single_arm', 'Seated Cable Row (Single Arm)', 'back', array['biceps']::muscle_group[], 'cable', null, true, 75, '1. Grip cable attachment, sit or stand tall.
2. Pull to abdomen or chest, leading with elbows.
3. Squeeze upper back at peak.
4. Return with control.'),
  ('incline_dumbbell_fly_flat', 'Flat Dumbbell Fly', 'chest', '{}'::muscle_group[], 'dumbbell', null, false, 90, '1. Lie flat on bench, press dumbbells to lockout.
2. Open arms wide in fly arc to shoulder height.
3. Feel deep chest stretch at bottom.
4. Bring dumbbells back together over midline, squeezing chest.'),
  ('dumbbell_shoulder_press_seated', 'Dumbbell Shoulder Press (Seated)', 'shoulders', array['triceps']::muscle_group[], 'dumbbell', null, false, 120, '1. Sit on bench with back support, dumbbells at shoulders.
2. Press to lockout overhead.
3. Squeeze at top.
4. Lower with control.'),
  ('front_raise_barbell', 'Front Raise (Barbell)', 'shoulders', '{}'::muscle_group[], 'barbell', null, false, 60, '1. Stand with barbell at thighs, overhand grip.
2. Raise bar to shoulder height, arms straight.
3. Control at top.
4. Lower slowly.'),
  ('upright_row_dumbbell', 'Upright Row (Dumbbell)', 'shoulders', array['biceps']::muscle_group[], 'dumbbell', null, false, 75, '1. Hold dumbbells at thighs, stand tall.
2. Pull dumbbells up along body to chin, elbows rise high.
3. Keep dumbbells close to torso.
4. Lower slowly.'),
  ('shrug_trap_bar', 'Trap Bar Shrug', 'back', '{}'::muscle_group[], 'barbell', null, false, 75, '1. Step into trap bar, grip handles, stand tall.
2. Shrug shoulders straight up toward ears.
3. Hold 1 second at top.
4. Lower fully.'),
  ('barbell_curl_wide', 'Wide Grip Barbell Curl', 'biceps', '{}'::muscle_group[], 'barbell', null, false, 75, '1. Hold barbell with wide overhand-supinated grip (wider than shoulder).
2. Curl to shoulders, feeling inner bicep head.
3. Squeeze at top.
4. Lower with control.'),
  ('barbell_curl_close', 'Close Grip Barbell Curl', 'biceps', '{}'::muscle_group[], 'barbell', null, false, 75, '1. Hold barbell with close supinated grip (hands 4-6" apart).
2. Curl to shoulders, emphasizing outer biceps head.
3. Squeeze at top.
4. Lower with control.'),
  ('sumo_squat_barbell', 'Sumo Squat (Barbell)', 'legs', array['glutes']::muscle_group[], 'barbell', null, false, 150, '1. Wide stance, toes pointed out, bar on upper back.
2. Squat down keeping chest tall and knees tracking toes.
3. Feel deep adductor and glute stretch.
4. Drive through heels.'),
  ('lunge_reverse_barbell', 'Reverse Lunge (Barbell)', 'legs', array['glutes']::muscle_group[], 'barbell', null, true, 120, '1. Bar on upper back, step one foot back.
2. Lower back knee toward floor.
3. Drive front heel to return.
4. Alternate or complete all reps one side.'),
  ('cable_abduction', 'Cable Hip Abduction', 'glutes', array['legs']::muscle_group[], 'cable', null, true, 60, '1. Attach ankle cuff to cable, stand sideways to stack.
2. Lift leg out to the side (abduction).
3. Squeeze glute and abductor at peak.
4. Return slowly.'),
  ('cable_adduction', 'Cable Hip Adduction', 'legs', '{}'::muscle_group[], 'cable', null, true, 60, '1. Attach ankle cuff to high cable, stand sideways.
2. Pull leg across body (adduction).
3. Squeeze inner thigh at peak.
4. Return with control.'),
  ('cable_pull_through', 'Cable Pull Through', 'glutes', array['legs','back']::muscle_group[], 'cable', null, false, 90, '1. Attach rope to low cable, stand facing away from stack.
2. Hinge at hips with rope between legs.
3. Drive hips forward to stand, squeezing glutes.
4. Hinge back to start.'),
  ('step_up_barbell', 'Step Up (Barbell)', 'legs', array['glutes']::muscle_group[], 'barbell', null, true, 90, '1. Bar on upper back, stand in front of box.
2. Step one foot fully on top of box.
3. Drive through top foot to stand.
4. Lower under control and alternate.'),
  ('belt_squat', 'Belt Squat', 'legs', array['glutes']::muscle_group[], 'machine', null, false, 150, '1. Hook weight belt around hips and stand on platform.
2. Weight hangs below, free to squat.
3. Squat to parallel without axial loading.
4. Drive through heels.'),
  ('ghd_sit_up', 'GHD Sit-Up', 'core', array['glutes']::muscle_group[], 'machine', null, false, 90, '1. Set on GHD with hips on pad, feet secured, start parallel to floor.
2. Lower torso toward floor (hyperextend at hips).
3. Sit up fully, touching hands to feet.
4. Lower slowly.'),
  ('cable_external_rotation', 'Cable External Rotation', 'shoulders', '{}'::muscle_group[], 'cable', null, true, 60, '1. Set cable at elbow height, stand sideways.
2. Hold forearm at 90°, elbow at side.
3. Rotate forearm away from body (external rotation).
4. Return with control.'),
  ('cable_internal_rotation', 'Cable Internal Rotation', 'shoulders', '{}'::muscle_group[], 'cable', null, true, 60, '1. Set cable at elbow height, stand sideways.
2. Hold forearm at 90°, elbow at side.
3. Rotate forearm across body (internal rotation).
4. Return with control.'),
  ('seated_dumbbell_shrug', 'Seated Dumbbell Shrug', 'back', '{}'::muscle_group[], 'dumbbell', null, false, 60, '1. Sit on bench, dumbbells at sides.
2. Shrug straight up.
3. Hold 1 second.
4. Lower slowly.'),
  ('shrug_cable', 'Cable Shrug', 'back', '{}'::muscle_group[], 'cable', null, false, 60, '1. Set cable low with straight bar.
2. Stand tall, grip bar.
3. Shrug shoulders straight up.
4. Lower with control.'),
  ('cable_row_chest_supported', 'Chest Supported Cable Row', 'back', array['biceps']::muscle_group[], 'cable', null, false, 90, '1. Sit at chest-supported cable row machine, chest against pad.
2. Grip handles, row to chest.
3. Squeeze shoulder blades together.
4. Return slowly.'),
  ('incline_cable_curl', 'Incline Cable Curl', 'biceps', '{}'::muscle_group[], 'cable', null, true, 75, '1. Set pulley low, set adjustable bench to 45° facing away from cable.
2. Sit back and curl cable handles up toward shoulders.
3. Squeeze biceps at top.
4. Return with control.'),
  ('kneeling_cable_pullover', 'Kneeling Cable Pullover', 'back', array['core']::muscle_group[], 'cable', null, false, 90, '1. Kneel facing away from high pulley, hold rope overhead.
2. Keeping arms nearly straight, pull rope forward and down to thighs.
3. Squeeze lats at bottom.
4. Return with control.'),
  ('decline_push_up_weighted', 'Weighted Decline Push-Up', 'chest', array['triceps']::muscle_group[], 'bodyweight', null, false, 90, '1. Feet on bench, hands on floor with weight vest or plate on back.
2. Lower chest to floor.
3. Press to lockout.
4. Core rigid throughout.'),
  ('ring_row', 'Ring Row', 'back', array['biceps']::muscle_group[], 'bodyweight', null, false, 90, '1. Set rings at waist height, lie below.
2. Pull chest to rings, body straight from heels.
3. Squeeze shoulder blades together.
4. Lower with control.'),
  ('superman_hold', 'Superman Hold', 'back', array['glutes']::muscle_group[], 'bodyweight', null, false, 60, '1. Lie face-down, arms extended overhead.
2. Simultaneously lift arms, chest, and legs off the floor.
3. Squeeze glutes and back extensors, hold 2-3 seconds.
4. Lower and repeat.'),
  ('bench_press_paused', 'Bench Press (Paused)', 'chest', array['triceps','shoulders']::muscle_group[], 'barbell', null, false, 180, '1. Set up for standard bench press, unrack bar.
2. Lower bar to chest and pause 2-3 seconds with full tension.
3. Do not bounce off chest; maintain tight position.
4. Press explosively to lockout.'),
  ('tempo_squat', 'Tempo Squat', 'legs', array['glutes','core']::muscle_group[], 'barbell', null, false, 150, '1. Bar on back, squat down with controlled 3-4 second descent.
2. Pause 1-2 seconds at bottom.
3. Drive back to standing.
4. Slow tempo maximizes time under tension.'),
  ('hip_flexor_stretch', 'Hip Flexor Stretch', 'legs', '{}'::muscle_group[], 'bodyweight', null, true, 30, '1. Lunge with one knee on floor.
2. Push hips forward and down.
3. Feel iliopsoas stretch.
4. Hold 30-60 seconds, switch sides.'),
  ('incline_dumbbell_bench_15', 'Low Incline Dumbbell Bench Press (15°)', 'chest', array['triceps']::muscle_group[], 'dumbbell', null, false, 120, '1. Set bench to low 15° incline.
2. Press dumbbells from chest to lockout.
3. Primarily targets lower-upper chest transition.
4. Lower with control.'),
  ('standing_ab_wheel', 'Standing Ab Wheel Rollout', 'core', array['back','shoulders']::muscle_group[], 'none', null, false, 90, '1. Hold ab wheel with arms straight, standing upright.
2. Roll wheel out and down toward floor.
3. Stop before losing lumbar control.
4. Roll back to standing.'),
  ('dragon_flag', 'Dragon Flag', 'core', array['back']::muscle_group[], 'bodyweight', null, false, 90, '1. Lie on bench, grip behind head for support.
2. Raise body straight from floor (only shoulders on bench).
3. Lower the rigid body back toward bench slowly.
4. Do not let hips sag.'),
  ('lateral_band_walk_monster', 'Monster Walk', 'glutes', array['legs']::muscle_group[], 'resistance_band', null, false, 60, '1. Loop band above knees, slight squat stance.
2. Step forward and diagonally, maintaining band tension.
3. Keep knees out against the band.
4. Walk 10-15 steps and reverse.'),
  ('resistance_band_hip_thrust', 'Resistance Band Hip Thrust', 'glutes', '{}'::muscle_group[], 'resistance_band', null, false, 60, '1. Loop band over hips, anchor ends.
2. Drive hips to full extension against band.
3. Squeeze glutes at top.
4. Lower with control.'),
  ('resistance_band_squat', 'Resistance Band Squat', 'legs', array['glutes']::muscle_group[], 'resistance_band', null, false, 60, '1. Stand on band, hold ends at shoulders.
2. Squat to parallel against band resistance.
3. Drive through heels to stand.
4. Band provides ascending resistance.'),
  ('resistance_band_chest_press', 'Resistance Band Chest Press', 'chest', array['triceps']::muscle_group[], 'resistance_band', null, false, 60, '1. Anchor band behind you at chest height, grip ends.
2. Press forward to full arm extension.
3. Squeeze chest at lockout.
4. Return with control.'),
  ('resistance_band_shoulder_press', 'Resistance Band Shoulder Press', 'shoulders', array['triceps']::muscle_group[], 'resistance_band', null, false, 60, '1. Stand on band, grip ends at shoulders.
2. Press hands overhead to lockout.
3. Control the resistance.
4. Lower with control.'),
  ('incline_barbell_bench_30', 'Incline Barbell Bench Press (30°)', 'chest', array['triceps','shoulders']::muscle_group[], 'barbell', null, false, 180, '1. Set bench to 30°, bar at upper-chest level.
2. Lower bar to upper chest.
3. Press to lockout.
4. Targets upper chest with lesser angle.'),
  ('dumbbell_pullover_incline', 'Incline Dumbbell Pullover', 'chest', array['back']::muscle_group[], 'dumbbell', null, false, 90, '1. Set bench to 30° incline, lie back with dumbbell at chest.
2. Arc dumbbell overhead with slight elbow bend.
3. Feel chest and lat stretch at end.
4. Pull back over chest.'),
  ('barbell_rollout', 'Barbell Rollout', 'core', array['back','shoulders']::muscle_group[], 'barbell', null, false, 90, '1. Kneel, grip barbell like an ab wheel.
2. Roll forward, extending arms and hips.
3. Pull back using abs.
4. Do not let hips sag.'),
  ('seated_leg_press_calf_raise', 'Leg Press Calf Raise', 'legs', '{}'::muscle_group[], 'machine', null, false, 60, '1. Sit in leg press, push platform to near-lockout.
2. Slide feet to ball of foot position (lower third of platform).
3. Press through toes to calf raise.
4. Lower and repeat.'),
  ('cable_squat', 'Cable Squat', 'legs', array['glutes']::muscle_group[], 'cable', null, false, 90, '1. Attach cable at waist level, stand facing stack.
2. Squat to parallel while holding cable.
3. Cable provides anterior resistance.
4. Drive through heels.'),
  ('db_spider_curl', 'Dumbbell Spider Curl', 'biceps', '{}'::muscle_group[], 'dumbbell', null, false, 75, '1. Lie face-down on incline bench, dumbbell in each hand hanging.
2. Curl dumbbells to chin.
3. Squeeze biceps at peak.
4. Lower fully.'),
  ('overhead_press_barbell_seated', 'Seated Barbell Overhead Press', 'shoulders', array['triceps']::muscle_group[], 'barbell', null, false, 150, '1. Sit on bench, bar at shoulder height in rack.
2. Grip just outside shoulders, unrack.
3. Press bar overhead to lockout.
4. Lower to collarbone.'),
  ('cable_lat_prayer', 'Cable Lat Prayer', 'back', array['core']::muscle_group[], 'cable', null, false, 75, '1. Attach rope to high pulley, kneel facing stack.
2. Hold rope with elbows locked beside head.
3. Crunch downward by flexing core, bringing rope toward knees.
4. Return slowly, feel thoracic extension.'),
  ('half_kneeling_cable_press', 'Half Kneeling Cable Press', 'shoulders', array['core']::muscle_group[], 'cable', null, true, 90, '1. Kneel on one knee facing away from cable, handle at shoulder.
2. Press cable forward and overhead in press arc.
3. Core braced to resist rotation.
4. Return with control.'),
  ('seated_calf_raise_barbell', 'Seated Calf Raise (Barbell)', 'legs', '{}'::muscle_group[], 'barbell', null, false, 60, '1. Stand or sit with balls of feet on platform.
2. Rise on toes as high as possible.
3. Hold at top for 1 second.
4. Lower heels for full stretch.'),
  ('wall_ball', 'Wall Ball', 'legs', array['shoulders','core']::muscle_group[], 'none', null, false, 60, '1. Hold med ball at chest, stand facing wall at ~10 feet.
2. Squat to parallel, then explode upward.
3. Release ball to target on wall at peak of jump.
4. Catch ball on return and immediately go into next squat.'),
  ('medball_slam', 'Medicine Ball Slam', 'core', array['shoulders','back']::muscle_group[], 'none', null, false, 60, '1. Hold med ball overhead with arms extended.
2. Slam ball to floor as hard as possible.
3. Pick up ball and reset.
4. Full body explosive movement.'),
  ('box_jump_step_down', 'Box Jump (Step Down)', 'legs', array['glutes']::muscle_group[], 'bodyweight', null, false, 90, '1. Jump onto box and land softly.
2. Stand fully on top.
3. Step (do not jump) down carefully.
4. Reset and repeat.'),
  ('depth_jump', 'Depth Jump', 'legs', array['glutes']::muscle_group[], 'bodyweight', null, false, 90, '1. Stand on elevated surface, step off and drop.
2. Land on both feet, immediately jump upward as fast as possible.
3. Minimize ground contact time.
4. Emphasizes stretch-shortening cycle.'),
  ('broad_jump', 'Broad Jump', 'legs', array['glutes']::muscle_group[], 'bodyweight', null, false, 90, '1. Stand with feet shoulder-width, arms swinging.
2. Dip and jump forward as far as possible.
3. Land on both feet with soft knees.
4. Measure or mark landing distance.'),
  ('cable_chest_fly_single_arm', 'Cable Chest Fly (Single Arm)', 'chest', array['triceps']::muscle_group[], 'cable', 'push_horizontal', true, 60, '1. Set cable at chest height, stand sideways to stack.
2. With far hand grab handle, slight elbow bend.
3. Pull handle across body, squeezing pec.
4. Return slowly and repeat.'),
  ('cable_chest_fly_squeeze', 'Cable Chest Fly (Squeeze)', 'chest', '{}'::muscle_group[], 'cable', 'push_horizontal', false, 60, '1. Set cables at mid-chest height.
2. Bring handles together and press palms together.
3. Hold squeeze for 2 seconds at peak contraction.
4. Slowly return to start.'),
  ('cable_fly_upper_chest', 'Cable Fly (Upper Chest)', 'chest', array['shoulders']::muscle_group[], 'cable', 'push_horizontal', false, 60, '1. Set cables at lowest position.
2. Stand with slight forward lean.
3. Bring handles up and together in front of chin.
4. Lower slowly, maintaining elbow bend.'),
  ('cable_crossover_single_arm', 'Cable Crossover (Single Arm)', 'chest', array['triceps']::muscle_group[], 'cable', 'push_horizontal', true, 60, '1. Set cable to shoulder height.
2. Stand sideways, grab handle with far hand.
3. Pull handle across midline, palm down at finish.
4. Control the return.'),
  ('cable_row_low_single_arm', 'Cable Row Low (Single Arm)', 'back', array['biceps']::muscle_group[], 'cable', 'pull_horizontal', true, 60, '1. Set pulley low, grab handle with one hand.
2. Sit or stand in split stance, keep back flat.
3. Row handle to hip, elbow tucking back.
4. Return with control.'),
  ('cable_pulldown_single_arm', 'Cable Pulldown (Single Arm)', 'back', array['biceps']::muscle_group[], 'cable', 'pull_vertical', true, 60, '1. Set cable high, kneel or sit facing stack.
2. Grab handle with one hand, arm extended.
3. Pull elbow down to hip, squeezing lat.
4. Return slowly.'),
  ('cable_row_high_single_arm', 'Cable Row High (Single Arm)', 'back', array['shoulders']::muscle_group[], 'cable', 'pull_horizontal', true, 60, '1. Set cable at face height.
2. Stand facing stack, grab handle with one hand.
3. Pull elbow back past torso, rotating shoulder blade.
4. Control return.'),
  ('cable_rear_delt_row', 'Cable Rear Delt Row', 'shoulders', array['back']::muscle_group[], 'cable', 'pull_horizontal', false, 60, '1. Set cables at shoulder height.
2. Cross arms and grab opposite handles.
3. Pull elbows wide and back, squeezing rear delts.
4. Return slowly.'),
  ('cable_lateral_raise_single_arm', 'Cable Lateral Raise (Single Arm)', 'shoulders', '{}'::muscle_group[], 'cable', 'push_horizontal', true, 60, '1. Set cable to low pulley, stand beside stack.
2. Grab handle with far hand.
3. Raise arm to shoulder height, slight elbow bend.
4. Lower with control.'),
  ('cable_shoulder_press_single', 'Cable Shoulder Press (Single Arm)', 'shoulders', array['triceps']::muscle_group[], 'cable', 'push_vertical', true, 60, '1. Set cable at shoulder height, stand sideways.
2. Grab handle at shoulder, press straight up.
3. Lock out overhead, keep core braced.
4. Lower slowly.'),
  ('cable_curl_single_arm_low', 'Cable Curl (Single Arm, Low)', 'biceps', '{}'::muscle_group[], 'cable', 'pull_vertical', true, 60, '1. Set pulley to floor.
2. Stand facing machine, curl handle up.
3. Keep upper arm still, squeeze at top.
4. Lower with control.'),
  ('cable_curl_cross_body', 'Cable Curl (Cross Body)', 'biceps', array['back']::muscle_group[], 'cable', 'pull_vertical', true, 60, '1. Set cable at floor level, stand sideways.
2. Grab handle with far arm, curl across body.
3. Squeeze bicep at top.
4. Lower slowly.'),
  ('cable_tricep_kickback', 'Cable Tricep Kickback', 'triceps', '{}'::muscle_group[], 'cable', 'push_horizontal', true, 60, '1. Set pulley low, hinge forward 45 degrees.
2. Lock upper arm parallel to floor.
3. Extend forearm back until arm is straight.
4. Return with control.'),
  ('cable_overhead_tricep_single', 'Cable Overhead Tricep Extension (Single Arm)', 'triceps', '{}'::muscle_group[], 'cable', 'push_vertical', true, 60, '1. Set cable high, grab handle behind head with one hand.
2. Brace elbow, extend forearm up.
3. Squeeze tricep at lockout.
4. Lower slowly.'),
  ('cable_pushdown_single_arm', 'Cable Pushdown (Single Arm)', 'triceps', '{}'::muscle_group[], 'cable', 'push_vertical', true, 60, '1. Set cable high, grab handle with one hand.
2. Tuck elbow to side.
3. Push handle down until arm is fully extended.
4. Return with control.'),
  ('cable_fly_mid_single', 'Cable Fly (Mid, Single Arm)', 'chest', '{}'::muscle_group[], 'cable', 'push_horizontal', true, 60, '1. Set cable at mid chest height.
2. Stand sideways, far hand grabs handle.
3. Sweep arm across chest, squeezing pec.
4. Return slowly.'),
  ('cable_hip_extension', 'Cable Hip Extension', 'glutes', array['legs']::muscle_group[], 'cable', 'hinge', true, 60, '1. Set cable low, attach strap to ankle.
2. Stand facing stack, slight forward lean.
3. Drive leg back and up, squeezing glute.
4. Return with control.'),
  ('cable_glute_kickback_standing', 'Cable Glute Kickback (Standing)', 'glutes', '{}'::muscle_group[], 'cable', 'hinge', true, 60, '1. Attach ankle strap to low cable.
2. Face stack holding for balance.
3. Kick leg straight back, squeezing glute at top.
4. Return slowly.'),
  ('cable_leg_curl_standing', 'Cable Leg Curl (Standing)', 'legs', array['glutes']::muscle_group[], 'cable', 'hinge', true, 60, '1. Attach ankle strap to low cable.
2. Face machine holding for support.
3. Curl heel toward glute, keeping thigh still.
4. Lower with control.'),
  ('cable_pull_apart', 'Cable Pull Apart', 'shoulders', array['back']::muscle_group[], 'cable', 'pull_horizontal', false, 30, '1. Set cable at chest height with rope attachment.
2. Hold both ends at chest, step back for tension.
3. Pull rope apart, retracting shoulder blades.
4. Slowly return.'),
  ('cable_woodchop_low_high', 'Cable Wood Chop (Low to High)', 'core', array['shoulders']::muscle_group[], 'cable', 'rotation', true, 60, '1. Set cable at floor level.
2. Stand sideways, grab handle with both hands.
3. Rotate hips and pull cable diagonally across body upward.
4. Control the return.'),
  ('cable_woodchop_high_low', 'Cable Wood Chop (High to Low)', 'core', array['shoulders']::muscle_group[], 'cable', 'rotation', true, 60, '1. Set cable high.
2. Stand sideways, grab handle overhead.
3. Pull cable diagonally across body downward.
4. Control the return.'),
  ('pallof_press_tall_kneeling', 'Pallof Press (Tall Kneeling)', 'core', '{}'::muscle_group[], 'cable', 'static', false, 60, '1. Kneel perpendicular to cable stack.
2. Hold handle at chest with both hands.
3. Press handle forward, resisting rotation.
4. Hold for count, bring back in.'),
  ('pallof_press_half_kneeling', 'Pallof Press (Half Kneeling)', 'core', '{}'::muscle_group[], 'cable', 'static', false, 60, '1. Kneel with inside knee down, perpendicular to cable.
2. Hold handle at chest.
3. Press straight out, resisting rotation.
4. Hold and return.'),
  ('cable_face_pull_rope', 'Cable Face Pull (Rope)', 'shoulders', array['back']::muscle_group[], 'cable', 'pull_horizontal', false, 60, '1. Attach rope to high pulley.
2. Grab rope with pronated grip, step back.
3. Pull rope to face, flaring elbows high.
4. Squeeze rear delts and return.'),
  ('cable_upright_row_rope', 'Cable Upright Row (Rope)', 'shoulders', array['biceps']::muscle_group[], 'cable', 'pull_vertical', false, 60, '1. Attach rope to low pulley.
2. Stand, pull rope up toward chin with elbows flaring.
3. Keep rope close to body.
4. Lower with control.'),
  ('cable_row_underhand', 'Cable Row (Underhand Grip)', 'back', array['biceps']::muscle_group[], 'cable', 'pull_horizontal', false, 60, '1. Attach straight bar to seated cable.
2. Grip bar underhand (supinated).
3. Row to lower abdomen, driving elbows back.
4. Return with control.'),
  ('lat_pulldown_wide_overhand', 'Lat Pulldown (Wide Overhand)', 'back', array['biceps']::muscle_group[], 'cable', 'pull_vertical', false, 90, '1. Grip bar wider than shoulder width, palms forward.
2. Pull bar to upper chest, driving elbows down.
3. Squeeze lats at bottom.
4. Return slowly.'),
  ('cable_concentration_curl', 'Cable Concentration Curl', 'biceps', '{}'::muscle_group[], 'cable', 'pull_vertical', true, 60, '1. Set pulley low, sit on bench facing machine.
2. Brace elbow on thigh, curl handle up.
3. Squeeze hard at top.
4. Lower with control.'),
  ('cable_curl_lying', 'Cable Curl (Lying)', 'biceps', '{}'::muscle_group[], 'cable', 'pull_vertical', false, 60, '1. Set cable low, lie on floor facing stack.
2. Hold bar overhead at arm length.
3. Curl handle toward forehead.
4. Lower with control.'),
  ('cable_tricep_pressdown_bar', 'Cable Tricep Pressdown (Bar)', 'triceps', '{}'::muscle_group[], 'cable', 'push_vertical', false, 60, '1. Attach straight bar to high cable.
2. Grip bar overhand, tuck elbows to sides.
3. Press down until arms fully extend.
4. Return with control.'),
  ('cable_bicep_curl_wide', 'Cable Bicep Curl (Wide Grip)', 'biceps', '{}'::muscle_group[], 'cable', 'pull_vertical', false, 60, '1. Attach straight bar to low pulley, grip wide.
2. Curl bar up, keeping upper arms stationary.
3. Squeeze biceps at top.
4. Lower with control.'),
  ('cable_bicep_curl_narrow', 'Cable Bicep Curl (Narrow Grip)', 'biceps', '{}'::muscle_group[], 'cable', 'pull_vertical', false, 60, '1. Attach straight bar, hands close together.
2. Curl bar keeping elbows tucked.
3. Squeeze at top.
4. Lower slowly.'),
  ('cable_chest_press_standing', 'Cable Chest Press (Standing)', 'chest', array['triceps','shoulders']::muscle_group[], 'cable', 'push_horizontal', false, 90, '1. Set cables at chest height, stand in split stance.
2. Press both handles forward until arms extend.
3. Hold slight elbow bend at lockout.
4. Return with control.'),
  ('cable_incline_fly', 'Cable Incline Fly', 'chest', '{}'::muscle_group[], 'cable', 'push_horizontal', false, 60, '1. Set cables low, lie on incline bench.
2. Press and arc handles together above upper chest.
3. Squeeze pecs at top.
4. Return with control.'),
  ('cable_reverse_curl_rope', 'Cable Reverse Curl (Rope)', 'biceps', array['shoulders']::muscle_group[], 'cable', 'pull_vertical', false, 60, '1. Attach rope to low cable, grip with pronated hands.
2. Curl up keeping palms facing down.
3. Squeeze brachialis at top.
4. Lower with control.'),
  ('cable_seated_crunch', 'Cable Seated Crunch', 'core', '{}'::muscle_group[], 'cable', 'pull_vertical', false, 60, '1. Sit on bench facing cable, set pulley high.
2. Hold rope behind head.
3. Crunch down, flexing abs fully.
4. Slowly return to upright.'),
  ('cable_hip_flexion_standing', 'Cable Hip Flexion (Standing)', 'core', array['legs']::muscle_group[], 'cable', 'hinge', true, 60, '1. Attach strap to low cable at ankle.
2. Face away from stack.
3. Drive knee up toward chest.
4. Control descent.'),
  ('cable_row_bayesian', 'Cable Row (Bayesian)', 'back', array['biceps']::muscle_group[], 'cable', 'pull_horizontal', true, 60, '1. Set cable at hip height, face away.
2. Hold handle behind body, slight lean forward.
3. Row elbow back, stretching lat fully.
4. Return with control.'),
  ('cable_hip_abduction_standing', 'Cable Hip Abduction (Standing)', 'glutes', '{}'::muscle_group[], 'cable', 'hinge', true, 60, '1. Attach strap to ankle, stand sideways to low cable.
2. Raise strapped leg out to side.
3. Keep torso upright.
4. Lower with control.'),
  ('cable_hip_adduction_standing', 'Cable Hip Adduction (Standing)', 'legs', '{}'::muscle_group[], 'cable', 'hinge', true, 60, '1. Attach strap to far ankle, stand sideways to low cable.
2. Pull leg across body, adducting.
3. Keep torso upright.
4. Return with control.'),
  ('cable_rear_delt_single_arm', 'Cable Rear Delt Fly (Single Arm)', 'shoulders', array['back']::muscle_group[], 'cable', 'pull_horizontal', true, 60, '1. Set cable at shoulder height or lower.
2. Stand sideways, grab far handle.
3. Pull across and back, squeezing rear delt.
4. Return with control.'),
  ('cable_lat_pullover_standing', 'Cable Lat Pullover (Standing)', 'back', array['core']::muscle_group[], 'cable', 'pull_vertical', false, 60, '1. Set cable high, grip rope or bar.
2. Step back, hinge forward slightly.
3. Pull handle down in arc toward hips.
4. Return slowly.'),
  ('cable_standing_oblique_crunch', 'Cable Standing Oblique Crunch', 'core', '{}'::muscle_group[], 'cable', 'rotation', true, 60, '1. Set cable high, stand sideways.
2. Reach up and grab handle with near hand.
3. Crunch torso down and toward hip.
4. Return with control.'),
  ('cable_straight_arm_pulldown_single', 'Cable Straight Arm Pulldown (Single Arm)', 'back', array['core']::muscle_group[], 'cable', 'pull_vertical', true, 60, '1. Set cable high, grab handle with straight arm.
2. Hinge slightly forward.
3. Pull arm down to hip keeping elbow locked.
4. Return with control.'),
  ('cable_shoulder_external_rotation_90', 'Cable External Rotation (90 Abduction)', 'shoulders', '{}'::muscle_group[], 'cable', 'rotation', true, 30, '1. Abduct arm to 90 degrees, elbow bent 90 degrees.
2. Set cable at elbow height.
3. Rotate forearm up, keeping elbow still.
4. Lower with control.'),
  ('cable_shoulder_internal_rotation_90', 'Cable Internal Rotation (90 Abduction)', 'shoulders', '{}'::muscle_group[], 'cable', 'rotation', true, 30, '1. Abduct arm to 90 degrees, elbow bent 90 degrees.
2. Set cable at elbow height.
3. Rotate forearm down.
4. Return with control.'),
  ('machine_chest_press', 'Chest Press (Machine)', 'chest', array['triceps','shoulders']::muscle_group[], 'machine', 'push_horizontal', false, 90, '1. Adjust seat so handles align with mid-chest.
2. Grip handles shoulder-width.
3. Press handles forward to near-lockout.
4. Return slowly with control.'),
  ('machine_shoulder_press', 'Shoulder Press (Machine)', 'shoulders', array['triceps']::muscle_group[], 'machine', 'push_vertical', false, 90, '1. Adjust seat height, handles at shoulder level.
2. Press handles overhead to lockout.
3. Keep lower back against pad.
4. Lower slowly.'),
  ('machine_row_single_arm', 'Machine Row (Single Arm)', 'back', array['biceps']::muscle_group[], 'machine', 'pull_horizontal', true, 60, '1. Sit facing chest pad, set single-arm handle.
2. Row with one arm, elbow close to side.
3. Squeeze lat at full contraction.
4. Return with control.'),
  ('machine_hip_thrust', 'Hip Thrust (Machine)', 'glutes', array['legs']::muscle_group[], 'machine', 'hinge', false, 90, '1. Adjust pad height so it rests across your hips.
2. Drive hips upward into full extension.
3. Squeeze glutes hard at top.
4. Lower with control.'),
  ('machine_glute_kickback', 'Glute Kickback (Machine)', 'glutes', '{}'::muscle_group[], 'machine', 'hinge', true, 60, '1. Kneel on machine pad, position ankle under roller.
2. Drive heel back until hip is extended.
3. Squeeze glute at top.
4. Return with control.'),
  ('machine_leg_extension_single', 'Leg Extension (Single Leg)', 'legs', '{}'::muscle_group[], 'machine', 'squat', true, 60, '1. Sit on leg extension, one leg under pad.
2. Extend lower leg until straight.
3. Hold briefly at top.
4. Lower with control.'),
  ('machine_calf_raise', 'Calf Raise (Machine)', 'legs', '{}'::muscle_group[], 'machine', 'squat', false, 60, '1. Stand on platform, pads on shoulders.
2. Lower heels below platform.
3. Rise onto toes as high as possible.
4. Hold and lower.'),
  ('machine_ab_crunch', 'Ab Crunch (Machine)', 'core', '{}'::muscle_group[], 'machine', 'pull_vertical', false, 60, '1. Adjust machine, grip handles at shoulders.
2. Crunch forward, contracting abs.
3. Hold at bottom.
4. Return slowly.'),
  ('machine_back_extension', 'Back Extension (Machine)', 'back', array['glutes']::muscle_group[], 'machine', 'hinge', false, 60, '1. Sit in machine, pads at lower back.
2. Extend torso back against pad.
3. Hold at full extension.
4. Return slowly.'),
  ('machine_preacher_curl', 'Preacher Curl (Machine)', 'biceps', '{}'::muscle_group[], 'machine', 'pull_vertical', false, 60, '1. Adjust seat, brace upper arms on pad.
2. Curl handles toward shoulders.
3. Squeeze at top.
4. Lower slowly.'),
  ('machine_tricep_extension', 'Tricep Extension (Machine)', 'triceps', '{}'::muscle_group[], 'machine', 'push_vertical', false, 60, '1. Sit at machine, grip handles above head.
2. Extend arms down fully.
3. Hold at lockout.
4. Return slowly.'),
  ('machine_lat_pulldown_single', 'Machine Lat Pulldown (Single Arm)', 'back', array['biceps']::muscle_group[], 'machine', 'pull_vertical', true, 60, '1. Use unilateral cable on pulldown machine.
2. Pull handle to shoulder height with one arm.
3. Squeeze lat fully.
4. Return with control.'),
  ('machine_seated_row', 'Seated Row (Machine)', 'back', array['biceps']::muscle_group[], 'machine', 'pull_horizontal', false, 90, '1. Sit chest against pad, grip handles.
2. Row handles back until elbows are behind torso.
3. Squeeze shoulder blades.
4. Return with control.'),
  ('machine_chest_fly', 'Chest Fly (Machine)', 'chest', '{}'::muscle_group[], 'machine', 'push_horizontal', false, 60, '1. Adjust seat so arms align with handles.
2. Bring arms together in front of chest.
3. Squeeze pecs at finish.
4. Open slowly.'),
  ('machine_pec_deck', 'Pec Deck (Machine)', 'chest', '{}'::muscle_group[], 'machine', 'push_horizontal', false, 60, '1. Sit upright, forearms on pads.
2. Bring pads together in front of chest.
3. Hold squeeze momentarily.
4. Open with control.'),
  ('machine_reverse_fly', 'Reverse Fly (Machine)', 'shoulders', array['back']::muscle_group[], 'machine', 'pull_horizontal', false, 60, '1. Sit facing pad, grip handles with arms forward.
2. Pull arms apart and back.
3. Squeeze rear delts.
4. Return with control.'),
  ('machine_incline_chest_press', 'Incline Chest Press (Machine)', 'chest', array['triceps','shoulders']::muscle_group[], 'machine', 'push_horizontal', false, 90, '1. Adjust inclined seat, handles at upper chest.
2. Press forward to near lockout.
3. Keep lower back on pad.
4. Lower with control.'),
  ('machine_decline_chest_press', 'Decline Chest Press (Machine)', 'chest', array['triceps']::muscle_group[], 'machine', 'push_horizontal', false, 90, '1. Sit in decline angle machine, handles at lower chest.
2. Press forward.
3. Control the return.
4. Keep core braced.'),
  ('machine_lateral_raise', 'Lateral Raise (Machine)', 'shoulders', '{}'::muscle_group[], 'machine', 'push_horizontal', false, 60, '1. Set pad against lower arm or wrist.
2. Raise arms out to sides to shoulder level.
3. Hold briefly at top.
4. Lower with control.'),
  ('machine_pullover', 'Pullover (Machine)', 'back', array['chest']::muscle_group[], 'machine', 'pull_vertical', false, 90, '1. Sit upright with elbows on pads overhead.
2. Pull pads down in arc to hips.
3. Squeeze lats at bottom.
4. Return slowly.'),
  ('machine_leg_curl_single', 'Leg Curl (Single Leg, Machine)', 'legs', '{}'::muscle_group[], 'machine', 'hinge', true, 60, '1. Lie on leg curl machine, one ankle under pad.
2. Curl heel toward glute.
3. Hold briefly.
4. Lower with control.'),
  ('machine_hip_abduction', 'Hip Abduction (Machine)', 'glutes', '{}'::muscle_group[], 'machine', 'hinge', false, 60, '1. Sit in machine, pads on outer thighs.
2. Push legs apart against resistance.
3. Hold briefly at wide position.
4. Return with control.'),
  ('machine_hip_adduction', 'Hip Adduction (Machine)', 'legs', '{}'::muscle_group[], 'machine', 'hinge', false, 60, '1. Sit in machine, pads on inner thighs.
2. Squeeze legs together.
3. Hold at end range.
4. Return with control.'),
  ('machine_bicep_curl', 'Bicep Curl (Machine)', 'biceps', '{}'::muscle_group[], 'machine', 'pull_vertical', false, 60, '1. Brace arms on pad, grip handles.
2. Curl handles toward shoulders.
3. Squeeze biceps at top.
4. Lower with control.'),
  ('machine_bicep_curl_single', 'Bicep Curl Machine (Single Arm)', 'biceps', '{}'::muscle_group[], 'machine', 'pull_vertical', true, 60, '1. Brace one arm, curl handle toward shoulder.
2. Keep upper arm stationary.
3. Squeeze at top.
4. Lower slowly.'),
  ('machine_shoulder_press_single', 'Shoulder Press Machine (Single Arm)', 'shoulders', array['triceps']::muscle_group[], 'machine', 'push_vertical', true, 60, '1. Set machine to single-arm mode.
2. Press handle overhead with one arm.
3. Keep torso stable.
4. Lower with control.'),
  ('machine_glute_drive', 'Glute Drive (Machine)', 'glutes', array['legs']::muscle_group[], 'machine', 'hinge', false, 90, '1. Position machine pad across hips.
2. Drive hips forward and up.
3. Squeeze glutes at full extension.
4. Lower with control.'),
  ('machine_torso_rotation', 'Torso Rotation (Machine)', 'core', '{}'::muscle_group[], 'machine', 'rotation', true, 60, '1. Sit in rotary torso machine.
2. Set start position, brace abs.
3. Rotate torso against resistance.
4. Return with control.'),
  ('machine_calf_raise_single', 'Calf Raise Machine (Single Leg)', 'legs', '{}'::muscle_group[], 'machine', 'squat', true, 60, '1. Stand on platform with one foot, pads on shoulder.
2. Lower heel below edge.
3. Rise onto toes as high as possible.
4. Hold and lower.'),
  ('machine_incline_row', 'Incline Row (Machine)', 'back', array['biceps']::muscle_group[], 'machine', 'pull_horizontal', false, 90, '1. Lie chest on inclined pad.
2. Grip handles below.
3. Row up squeezing shoulder blades.
4. Lower with control.'),
  ('machine_seated_shrug', 'Seated Shrug (Machine)', 'back', '{}'::muscle_group[], 'machine', 'pull_vertical', false, 60, '1. Sit at machine with handles at side.
2. Elevate shoulders straight up.
3. Hold at top briefly.
4. Lower fully.'),
  ('machine_tricep_dip', 'Machine Tricep Dip', 'triceps', array['chest']::muscle_group[], 'machine', 'push_vertical', false, 60, '1. Sit in machine, hands on handles at side.
2. Press down, extending elbows fully.
3. Hold at lockout.
4. Return with control.'),
  ('machine_calf_press', 'Calf Press (Machine)', 'legs', '{}'::muscle_group[], 'machine', 'squat', false, 60, '1. On leg press, place balls of feet at bottom of platform.
2. Press platform up with toes.
3. Lower heels below level.
4. Press up and repeat.'),
  ('machine_low_row', 'Low Row (Machine)', 'back', array['biceps']::muscle_group[], 'machine', 'pull_horizontal', false, 90, '1. Sit at machine, set handle at waist height.
2. Row handles to lower abdomen.
3. Drive elbows back, squeeze lats.
4. Return with control.'),
  ('machine_high_row', 'High Row (Machine)', 'back', array['biceps','shoulders']::muscle_group[], 'machine', 'pull_horizontal', false, 90, '1. Sit at machine, handles at shoulder level.
2. Pull handles toward face, elbows flaring high.
3. Squeeze upper back.
4. Return with control.'),
  ('machine_leg_press_wide', 'Leg Press (Wide Stance)', 'legs', array['glutes']::muscle_group[], 'machine', 'squat', false, 90, '1. Place feet wide and high on platform.
2. Lower platform to 90 degree knee angle.
3. Press through heels, emphasizing glutes.
4. Control the descent.'),
  ('machine_leg_press_narrow', 'Leg Press (Narrow Stance)', 'legs', '{}'::muscle_group[], 'machine', 'squat', false, 90, '1. Place feet close together and low on platform.
2. Lower to 90 degrees.
3. Press, emphasizing quads.
4. Control the descent.'),
  ('machine_leg_extension_slow', 'Leg Extension (Slow Tempo)', 'legs', '{}'::muscle_group[], 'machine', 'squat', false, 60, '1. Sit in leg extension machine.
2. Extend legs over 3 to 4 seconds.
3. Hold at top for 2 seconds.
4. Lower over 3 seconds.'),
  ('smith_machine_lunge', 'Smith Machine Lunge', 'legs', array['glutes']::muscle_group[], 'machine', 'lunge', true, 90, '1. Place bar on traps in smith machine.
2. Step one foot forward into split stance.
3. Lower back knee toward floor.
4. Drive up through front heel.'),
  ('smith_machine_calf_raise', 'Smith Machine Calf Raise', 'legs', '{}'::muscle_group[], 'machine', 'squat', false, 60, '1. Stand with toes on elevated surface, bar on traps.
2. Lower heels below platform.
3. Rise onto toes as high as possible.
4. Lower with control.'),
  ('smith_machine_rdl', 'Smith Machine Romanian Deadlift', 'legs', array['glutes','back']::muscle_group[], 'machine', 'hinge', false, 90, '1. Stand with bar at hip height in smith machine.
2. Hinge hips back, bar slides down legs.
3. Feel hamstring stretch at bottom.
4. Drive hips forward to return.'),
  ('machine_preacher_curl_single', 'Preacher Curl Machine (Single Arm)', 'biceps', '{}'::muscle_group[], 'machine', 'pull_vertical', true, 60, '1. Brace one arm on pad.
2. Curl handle toward shoulder.
3. Squeeze bicep at top.
4. Lower slowly.'),
  ('machine_seated_leg_curl', 'Seated Leg Curl (Machine)', 'legs', '{}'::muscle_group[], 'machine', 'hinge', false, 60, '1. Sit upright, ankle pads above heels.
2. Curl heels down and back.
3. Squeeze hamstrings at bottom.
4. Return with control.'),
  ('machine_torso_flexion', 'Torso Flexion (Machine)', 'core', '{}'::muscle_group[], 'machine', 'pull_vertical', false, 60, '1. Sit in machine, arms braced overhead.
2. Crunch forward against resistance.
3. Hold at peak contraction.
4. Return slowly.'),
  ('smith_machine_incline_press', 'Smith Machine Incline Press', 'chest', array['triceps','shoulders']::muscle_group[], 'machine', 'push_horizontal', false, 90, '1. Set incline bench under smith machine bar.
2. Grip shoulder-width, press up and back.
3. Lower to upper chest.
4. Press back up.'),
  ('smith_machine_decline_press', 'Smith Machine Decline Press', 'chest', array['triceps']::muscle_group[], 'machine', 'push_horizontal', false, 90, '1. Set decline bench, secure feet.
2. Grip bar shoulder-width.
3. Lower to lower chest.
4. Press up.'),
  ('machine_crossover_fly', 'Cable Machine Crossover Fly', 'chest', '{}'::muscle_group[], 'machine', 'push_horizontal', false, 60, '1. Stand between two pulley stations.
2. With arms wide, bring handles together.
3. Squeeze pecs at center.
4. Open arms slowly.'),
  ('machine_leg_press_single', 'Single Leg Press (Machine)', 'legs', array['glutes']::muscle_group[], 'machine', 'squat', true, 90, '1. Sit on leg press, place one foot in center of platform.
2. Lower platform by bending knee to 90 degrees.
3. Press through heel to extend leg.
4. Control the descent.'),
  ('single_arm_dumbbell_press', 'Single Arm Dumbbell Press', 'chest', array['triceps','shoulders']::muscle_group[], 'dumbbell', 'push_horizontal', true, 90, '1. Lie on bench, hold one dumbbell at chest.
2. Press straight up, bracing core against rotation.
3. Lower slowly.
4. Complete all reps then switch.'),
  ('single_arm_overhead_press_db', 'Single Arm Overhead Press (Dumbbell)', 'shoulders', array['triceps']::muscle_group[], 'dumbbell', 'push_vertical', true, 90, '1. Stand or sit, hold one dumbbell at shoulder.
2. Press overhead to lockout.
3. Keep torso upright, brace core.
4. Lower slowly.'),
  ('single_arm_barbell_row', 'Single Arm Barbell Row', 'back', array['biceps']::muscle_group[], 'barbell', 'pull_horizontal', true, 90, '1. Place barbell in corner or landmine.
2. Stand perpendicular, hinge to 45 degrees.
3. Row barbell to hip, driving elbow back.
4. Control the descent.'),
  ('single_leg_rdl_dumbbell', 'Single Leg Romanian Deadlift (Dumbbell)', 'legs', array['glutes','back']::muscle_group[], 'dumbbell', 'hinge', true, 90, '1. Stand on one leg, hold dumbbell in opposite hand.
2. Hinge forward, extending free leg behind.
3. Feel hamstring stretch.
4. Drive hip forward to return.'),
  ('single_leg_rdl_barbell', 'Single Leg Romanian Deadlift (Barbell)', 'legs', array['glutes','back']::muscle_group[], 'barbell', 'hinge', true, 90, '1. Stand on one leg holding barbell.
2. Hinge from hip, free leg lifts behind.
3. Lower bar to mid-shin.
4. Drive through standing heel to return.'),
  ('step_up_dumbbell', 'Step-Up (Dumbbell)', 'legs', array['glutes']::muscle_group[], 'dumbbell', 'lunge', true, 60, '1. Hold dumbbells, stand in front of box.
2. Step up with one foot, drive through heel.
3. Bring other foot up.
4. Step down and alternate.'),
  ('step_up_weighted', 'Step-Up (Barbell)', 'legs', array['glutes']::muscle_group[], 'barbell', 'lunge', true, 90, '1. Barbell on traps, stand before box.
2. Step up with lead leg, press to standing.
3. Bring rear leg up.
4. Step down.'),
  ('step_up_bodyweight', 'Step-Up (Bodyweight)', 'legs', array['glutes']::muscle_group[], 'bodyweight', 'lunge', true, 60, '1. Stand before box or step.
2. Step up with one foot, drive through heel.
3. Stand fully on top.
4. Step down and alternate.'),
  ('bulgarian_split_squat_barbell', 'Bulgarian Split Squat (Barbell)', 'legs', array['glutes']::muscle_group[], 'barbell', 'lunge', true, 120, '1. Bar on traps, rear foot elevated on bench.
2. Lower front knee toward floor.
3. Keep torso upright.
4. Drive through front heel to return.'),
  ('bulgarian_split_squat_dumbbell', 'Bulgarian Split Squat (Dumbbell)', 'legs', array['glutes']::muscle_group[], 'dumbbell', 'lunge', true, 90, '1. Hold dumbbells, rear foot on bench.
2. Lower into lunge position.
3. Keep front shin vertical.
4. Drive up through front heel.'),
  ('pistol_squat_weighted', 'Pistol Squat (Weighted)', 'legs', array['glutes','core']::muscle_group[], 'dumbbell', 'squat', true, 90, '1. Hold dumbbell in front for counterbalance.
2. Stand on one leg, extend free leg forward.
3. Lower into full squat on single leg.
4. Drive up through heel.'),
  ('single_leg_calf_raise_dumbbell', 'Single Leg Calf Raise (Dumbbell)', 'legs', '{}'::muscle_group[], 'dumbbell', 'squat', true, 60, '1. Stand on one foot on edge of step, hold dumbbell.
2. Lower heel below step.
3. Rise onto toes.
4. Hold and lower.'),
  ('single_arm_lat_pulldown', 'Single Arm Lat Pulldown', 'back', array['biceps']::muscle_group[], 'cable', 'pull_vertical', true, 60, '1. Kneel or sit at cable, grab handle with one hand.
2. Pull elbow down to side, squeezing lat.
3. Keep torso still.
4. Return with control.'),
  ('single_arm_tricep_pushdown', 'Single Arm Tricep Pushdown', 'triceps', '{}'::muscle_group[], 'cable', 'push_vertical', true, 60, '1. Grab single handle on high cable.
2. Tuck elbow to side.
3. Push down to full extension.
4. Return with control.'),
  ('single_arm_preacher_curl_db', 'Single Arm Preacher Curl (Dumbbell)', 'biceps', '{}'::muscle_group[], 'dumbbell', 'pull_vertical', true, 60, '1. Brace one arm on preacher pad with dumbbell.
2. Curl up to shoulder.
3. Squeeze bicep at top.
4. Lower slowly.'),
  ('single_arm_kettlebell_press', 'Single Arm Kettlebell Press', 'shoulders', array['triceps','core']::muscle_group[], 'kettlebell', 'push_vertical', true, 90, '1. Clean kettlebell to rack position.
2. Press overhead to lockout.
3. Brace core against rotation.
4. Lower with control.'),
  ('single_leg_hip_thrust_barbell', 'Single Leg Hip Thrust (Barbell)', 'glutes', array['legs']::muscle_group[], 'barbell', 'hinge', true, 90, '1. Upper back on bench, bar on hip, one leg extended.
2. Drive working hip up to full extension.
3. Squeeze glute hard.
4. Lower with control.'),
  ('single_leg_glute_bridge_weighted', 'Single Leg Glute Bridge (Weighted)', 'glutes', array['legs']::muscle_group[], 'dumbbell', 'hinge', true, 60, '1. Lie on back, weight on hip, one leg extended.
2. Drive working heel down, push hip up.
3. Squeeze glute at top.
4. Lower with control.'),
  ('single_arm_chest_fly_dumbbell', 'Single Arm Chest Fly (Dumbbell)', 'chest', '{}'::muscle_group[], 'dumbbell', 'push_horizontal', true, 60, '1. Lie on bench, hold one dumbbell directly above chest.
2. Lower arm in arc, stretching pec.
3. Bring arm back to center.
4. Other hand stabilizes on bench.'),
  ('lateral_step_up', 'Lateral Step-Up', 'legs', array['glutes']::muscle_group[], 'bodyweight', 'lunge', true, 60, '1. Stand beside box.
2. Step laterally up with near leg.
3. Stand fully on box.
4. Step back down.'),
  ('single_arm_dumbbell_tricep_extension', 'Single Arm Dumbbell Tricep Extension', 'triceps', '{}'::muscle_group[], 'dumbbell', 'push_vertical', true, 60, '1. Hold dumbbell overhead with one arm.
2. Lower behind head by bending elbow.
3. Extend arm back to lockout.
4. Control the descent.'),
  ('single_leg_squat_to_box', 'Single Leg Squat to Box', 'legs', array['glutes','core']::muscle_group[], 'bodyweight', 'squat', true, 90, '1. Stand in front of box.
2. Balance on one leg, extend other forward.
3. Lower to sit on box briefly.
4. Stand back up with control.'),
  ('single_arm_barbell_press_landmine', 'Single Arm Landmine Press', 'shoulders', array['triceps','chest']::muscle_group[], 'barbell', 'push_vertical', true, 90, '1. Place barbell end in landmine.
2. Grip near end at shoulder level.
3. Press diagonally up to lockout.
4. Lower with control.'),
  ('banded_single_leg_curl', 'Banded Single Leg Curl', 'legs', '{}'::muscle_group[], 'resistance_band', 'hinge', true, 60, '1. Anchor band low, loop around ankle.
2. Face anchor, curl heel toward glute.
3. Keep thigh still.
4. Lower with control.'),
  ('cossack_squat', 'Cossack Squat', 'legs', array['glutes']::muscle_group[], 'bodyweight', 'squat', true, 60, '1. Stand wide, arms forward for balance.
2. Shift weight to one side, squatting onto that leg.
3. Other leg stays straight.
4. Rise and shift to other side.'),
  ('single_arm_cable_chest_press', 'Single Arm Cable Chest Press', 'chest', array['triceps']::muscle_group[], 'cable', 'push_horizontal', true, 90, '1. Set cable at chest height, stand in split stance.
2. Grip handle with one hand at shoulder.
3. Press forward and slightly across.
4. Return with control.'),
  ('single_arm_dumbbell_row_bench', 'Single Arm Dumbbell Row (Bench)', 'back', array['biceps']::muscle_group[], 'dumbbell', 'pull_horizontal', true, 90, '1. Place one hand and knee on bench for support.
2. Hold dumbbell in free hand.
3. Row to hip, driving elbow back.
4. Lower with control.'),
  ('worlds_greatest_stretch', 'World''s Greatest Stretch', 'legs', array['core','shoulders']::muscle_group[], 'none', 'static', false, 30, '1. Start in push-up position.
2. Step one foot to outside of same-side hand.
3. Drop hip and rotate arm open toward sky.
4. Return and alternate.'),
  ('thoracic_rotation_stretch', 'Thoracic Rotation Stretch', 'back', '{}'::muscle_group[], 'none', 'rotation', false, 30, '1. Lie on side, knees stacked at 90 degrees.
2. Place hand behind head.
3. Rotate upper back open, reaching arm to opposite side.
4. Return and repeat.'),
  ('cat_cow', 'Cat-Cow', 'back', array['core']::muscle_group[], 'none', 'static', false, 30, '1. On hands and knees, spine neutral.
2. Inhale: arch back, look up (cow).
3. Exhale: round back, tuck chin (cat).
4. Flow between positions.'),
  ('shoulder_dislocates', 'Shoulder Dislocates', 'shoulders', '{}'::muscle_group[], 'none', 'static', false, 30, '1. Hold band or dowel wide.
2. Lift overhead in arc, bring behind back.
3. Return the same arc.
4. Gradually narrow grip as mobility improves.'),
  ('band_pull_apart_overhead', 'Band Pull-Apart (Overhead)', 'shoulders', array['back']::muscle_group[], 'resistance_band', 'pull_horizontal', false, 30, '1. Hold band overhead with wide grip.
2. Pull band apart behind head.
3. Stretch fully.
4. Return to start.'),
  ('hip_90_90_rotation', 'Hip 90/90 Rotation', 'glutes', array['legs']::muscle_group[], 'none', 'rotation', false, 30, '1. Sit with both legs at 90 degree angles.
2. Front leg is in external rotation, rear in internal.
3. Transition hips to switch leg positions.
4. Maintain upright torso.'),
  ('ankle_mobility_stretch', 'Ankle Mobility Stretch', 'legs', '{}'::muscle_group[], 'none', 'static', false, 30, '1. Place foot on wall or step.
2. Drive knee forward over toes.
3. Feel stretch in calf and ankle.
4. Hold and return.'),
  ('lying_glute_stretch', 'Lying Glute Stretch', 'glutes', '{}'::muscle_group[], 'none', 'static', true, 30, '1. Lie on back.
2. Cross ankle over opposite knee.
3. Pull bent knee toward chest.
4. Feel stretch in glute.'),
  ('prayer_stretch_thoracic', 'Prayer Stretch (Thoracic)', 'back', array['shoulders']::muscle_group[], 'none', 'static', false, 30, '1. Kneel before bench, hands flat on surface.
2. Sit hips back toward heels.
3. Extend arms forward, letting chest drop.
4. Hold and breathe.'),
  ('doorway_chest_stretch', 'Doorway Chest Stretch', 'chest', array['shoulders']::muscle_group[], 'none', 'static', false, 30, '1. Stand in doorway, arms on frame at 90 degrees.
2. Step forward, let chest open.
3. Hold the stretch.
4. Adjust arm height for different pec fibers.'),
  ('upper_trap_neck_stretch', 'Upper Trap and Neck Stretch', 'back', '{}'::muscle_group[], 'none', 'static', true, 30, '1. Sit or stand upright.
2. Tilt ear toward shoulder.
3. Gently add hand pressure for deeper stretch.
4. Hold then switch sides.'),
  ('calf_stretch_wall', 'Calf Stretch (Wall)', 'legs', '{}'::muscle_group[], 'none', 'static', true, 30, '1. Stand facing wall, hands on surface.
2. Extend one leg back, heel flat.
3. Drive front knee forward while keeping rear heel down.
4. Hold.'),
  ('hamstring_floor_stretch', 'Hamstring Floor Stretch', 'legs', '{}'::muscle_group[], 'none', 'static', true, 30, '1. Lie on back, raise one leg.
2. Grip behind knee or use strap.
3. Straighten leg, feeling hamstring stretch.
4. Hold and switch.'),
  ('quadriceps_stretch_standing', 'Quadriceps Stretch (Standing)', 'legs', '{}'::muscle_group[], 'none', 'static', true, 30, '1. Stand on one leg, bend other knee.
2. Hold ankle behind you.
3. Keep knees together, feel quad stretch.
4. Hold and switch.'),
  ('child_pose', 'Child''s Pose', 'back', array['shoulders']::muscle_group[], 'none', 'static', false, 30, '1. Kneel, sit hips back to heels.
2. Walk hands forward, forehead to ground.
3. Reach arms overhead or alongside body.
4. Hold and breathe.'),
  ('seated_piriformis_stretch', 'Seated Piriformis Stretch', 'glutes', '{}'::muscle_group[], 'none', 'static', true, 30, '1. Sit in chair, cross ankle over knee.
2. Press down gently on crossed knee.
3. Lean forward from hips.
4. Feel stretch in glute.'),
  ('lat_stretch_band', 'Lat Stretch (Band)', 'back', '{}'::muscle_group[], 'resistance_band', 'static', true, 30, '1. Anchor band overhead.
2. Grip with one hand, step back.
3. Allow body to hang or lean away.
4. Feel lat stretch.'),
  ('sleeper_stretch', 'Sleeper Stretch', 'shoulders', '{}'::muscle_group[], 'none', 'static', true, 30, '1. Lie on side, elbow at 90 degrees.
2. Use other hand to gently push wrist toward ground.
3. Feel stretch in posterior shoulder.
4. Hold.'),
  ('cross_body_shoulder_stretch', 'Cross Body Shoulder Stretch', 'shoulders', '{}'::muscle_group[], 'none', 'static', true, 30, '1. Bring one arm across chest.
2. Use other arm to press it closer.
3. Feel rear delt and shoulder stretch.
4. Hold and switch.'),
  ('wrist_extension_stretch', 'Wrist Extension Stretch', 'shoulders', '{}'::muscle_group[], 'none', 'static', true, 30, '1. Extend arm, palm up.
2. Use other hand to gently press fingers down.
3. Feel stretch in forearm.
4. Hold and switch.'),
  ('wrist_flexion_stretch', 'Wrist Flexion Stretch', 'shoulders', '{}'::muscle_group[], 'none', 'static', true, 30, '1. Extend arm, palm down.
2. Use other hand to press fingers down.
3. Feel stretch in top of forearm.
4. Hold and switch.'),
  ('hip_circle_standing', 'Hip Circle (Standing)', 'glutes', array['core']::muscle_group[], 'none', 'rotation', false, 30, '1. Stand with hands on hips.
2. Draw large circles with hips.
3. Complete circles in one direction.
4. Reverse.'),
  ('inchworm', 'Inchworm', 'core', array['shoulders','legs']::muscle_group[], 'none', 'static', false, 30, '1. Stand, hinge forward and walk hands out to push-up position.
2. Hold briefly.
3. Walk feet toward hands.
4. Stand and repeat.'),
  ('spiderman_stretch', 'Spiderman Stretch', 'legs', array['core']::muscle_group[], 'none', 'static', true, 30, '1. Start in push-up position.
2. Bring one foot to outside of same hand.
3. Press hip toward ground.
4. Return and switch.'),
  ('thoracic_extension_foam_roller', 'Thoracic Extension (Foam Roller)', 'back', '{}'::muscle_group[], 'none', 'static', false, 30, '1. Place foam roller across mid-back.
2. Support head, let back extend over roller.
3. Move roller up and down spine.
4. Breathe and relax.'),
  ('hip_flexor_lunge_stretch', 'Hip Flexor Lunge Stretch', 'legs', '{}'::muscle_group[], 'none', 'static', true, 30, '1. Kneel on one knee, other foot forward.
2. Drive hips forward until stretch in front of rear hip.
3. Keep torso tall.
4. Hold and switch.'),
  ('side_lying_quad_stretch', 'Side Lying Quad Stretch', 'legs', '{}'::muscle_group[], 'none', 'static', true, 30, '1. Lie on side.
2. Bend top knee, hold ankle.
3. Pull heel toward glutes.
4. Keep knees together.'),
  ('standing_it_band_stretch', 'IT Band Stretch (Standing)', 'legs', '{}'::muscle_group[], 'none', 'static', true, 30, '1. Cross one foot behind other.
2. Lean torso to side of front leg.
3. Feel stretch along outer thigh.
4. Hold and switch.'),
  ('banded_hip_flexor_stretch', 'Banded Hip Flexor Stretch', 'legs', array['glutes']::muscle_group[], 'resistance_band', 'static', true, 30, '1. Loop band at knee height on rack.
2. Step forward into lunge, band pulling hip back.
3. Drive hip forward against band tension.
4. Hold and feel anterior hip stretch.'),
  ('overhead_shoulder_stretch', 'Overhead Shoulder Stretch', 'shoulders', array['triceps']::muscle_group[], 'none', 'static', true, 30, '1. Raise one arm overhead, bend elbow.
2. Use other hand to gently press elbow toward head.
3. Feel tricep and shoulder stretch.
4. Hold and switch.'),
  ('seated_forward_fold', 'Seated Forward Fold', 'legs', array['back']::muscle_group[], 'none', 'static', false, 30, '1. Sit on floor with legs extended.
2. Hinge from hips, reaching toward feet.
3. Keep back flat.
4. Hold at deepest comfortable point.'),
  ('downward_dog', 'Downward Dog', 'back', array['legs','shoulders']::muscle_group[], 'none', 'static', false, 30, '1. Start in push-up position.
2. Drive hips up and back into inverted V.
3. Press heels toward ground.
4. Hold and breathe.'),
  ('standing_toe_touch', 'Standing Toe Touch', 'legs', array['back']::muscle_group[], 'none', 'hinge', false, 30, '1. Stand tall, feet hip-width.
2. Hinge forward with soft knees.
3. Reach fingers toward toes.
4. Hold briefly and stand up.'),
  ('scorpion_stretch', 'Scorpion Stretch', 'back', array['glutes']::muscle_group[], 'none', 'rotation', true, 30, '1. Lie face down, arms out to sides.
2. Lift one leg and cross it to opposite side.
3. Reach foot toward opposite hand.
4. Hold and switch.'),
  ('butterfly_stretch', 'Butterfly Stretch', 'legs', array['glutes']::muscle_group[], 'none', 'static', false, 30, '1. Sit with soles of feet together.
2. Pull heels toward groin.
3. Gently press knees toward ground.
4. Hold and breathe.'),
  ('prone_press_up', 'Prone Press-Up (Cobra)', 'back', '{}'::muscle_group[], 'none', 'static', false, 30, '1. Lie face down, hands under shoulders.
2. Press upper body up, hips on floor.
3. Extend back, look forward.
4. Hold and breathe.'),
  ('figure_four_stretch', 'Figure Four Stretch', 'glutes', '{}'::muscle_group[], 'none', 'static', true, 30, '1. Sit in chair, cross ankle over knee in 4 shape.
2. Lean forward.
3. Feel deep stretch in glute.
4. Switch sides.'),
  ('forward_lunge_twist', 'Forward Lunge with Twist', 'core', array['legs']::muscle_group[], 'none', 'rotation', true, 30, '1. Lunge forward with right leg.
2. Rotate torso toward right leg.
3. Hold.
4. Return and repeat on other side.'),
  ('thread_needle', 'Thread the Needle', 'back', array['shoulders']::muscle_group[], 'none', 'rotation', true, 30, '1. On hands and knees.
2. Slide one hand under body, rotating spine.
3. Lower shoulder to ground.
4. Hold and switch.'),
  ('tuck_jump', 'Tuck Jump', 'legs', array['core']::muscle_group[], 'bodyweight', null, false, 45, '1. Stand with feet shoulder-width.
2. Jump explosively, pulling knees to chest.
3. Land softly with bent knees.
4. Reset and repeat.'),
  ('bounding', 'Bounding', 'legs', array['glutes']::muscle_group[], 'bodyweight', null, true, 45, '1. Run forward with exaggerated strides.
2. Drive knee up and leap off back foot.
3. Cover maximum horizontal distance per stride.
4. Land on opposite foot.'),
  ('jump_squat_barbell', 'Jump Squat (Barbell)', 'legs', array['glutes']::muscle_group[], 'barbell', null, false, 90, '1. Bar on traps, use light weight.
2. Squat to parallel.
3. Explode upward, leaving the ground.
4. Land softly, absorb impact.'),
  ('jump_squat_goblet', 'Jump Squat (Goblet)', 'legs', array['core']::muscle_group[], 'kettlebell', null, false, 60, '1. Hold kettlebell at chest.
2. Descend into squat.
3. Explode up.
4. Land softly and reset.'),
  ('lateral_bound', 'Lateral Bound', 'legs', array['glutes']::muscle_group[], 'bodyweight', null, true, 60, '1. Stand on one leg.
2. Jump laterally, landing on opposite leg.
3. Stick landing.
4. Repeat in opposite direction.'),
  ('hurdle_jump', 'Hurdle Jump', 'legs', array['core']::muscle_group[], 'bodyweight', null, false, 60, '1. Stand before hurdle.
2. Jump over with two feet.
3. Land softly with bent knees.
4. Repeat over next hurdle.'),
  ('skater_jump', 'Skater Jump', 'legs', array['glutes']::muscle_group[], 'bodyweight', null, true, 45, '1. Jump laterally off one foot.
2. Land on opposite foot, other behind.
3. Immediately jump back.
4. Drive arms for power.'),
  ('reactive_step_up', 'Reactive Step-Up', 'legs', array['glutes']::muscle_group[], 'bodyweight', null, true, 60, '1. Step up on box.
2. Drive opposite knee up and jump from box.
3. Land softly on floor.
4. Alternate legs.'),
  ('clap_push_up_plyometric', 'Plyometric Push-Up', 'chest', array['triceps','shoulders']::muscle_group[], 'bodyweight', 'push_horizontal', false, 60, '1. Descend in push-up position.
2. Push explosively off floor.
3. Optional: clap hands in air.
4. Catch with soft elbows.'),
  ('medball_chest_throw', 'Medicine Ball Chest Throw', 'chest', array['triceps','shoulders']::muscle_group[], 'none', 'push_horizontal', false, 45, '1. Hold med ball at chest.
2. Throw explosively against wall or to partner.
3. Catch and reset.
4. Focus on speed.'),
  ('medball_overhead_throw', 'Medicine Ball Overhead Throw', 'shoulders', array['core','back']::muscle_group[], 'none', 'push_vertical', false, 45, '1. Hold med ball overhead.
2. Throw down hard against floor.
3. Catch on bounce or pick up.
4. Reset and repeat.'),
  ('medball_rotational_throw', 'Rotational Medicine Ball Throw', 'core', array['shoulders']::muscle_group[], 'none', 'rotation', true, 45, '1. Stand sideways to wall, hold med ball.
2. Rotate and throw ball against wall.
3. Catch and rotate back.
4. Complete reps then switch.'),
  ('box_jump_weighted', 'Box Jump (Weighted)', 'legs', array['glutes']::muscle_group[], 'dumbbell', null, false, 90, '1. Hold light dumbbells, stand before box.
2. Jump explosively onto box.
3. Land with soft knees.
4. Step down and repeat.'),
  ('plyo_lunge_jump', 'Plyo Lunge Jump', 'legs', array['glutes']::muscle_group[], 'bodyweight', 'lunge', true, 60, '1. Drop into lunge.
2. Jump explosively, switching legs in mid-air.
3. Land in opposite lunge.
4. Maintain rhythm.'),
  ('single_leg_box_jump', 'Single Leg Box Jump', 'legs', array['glutes']::muscle_group[], 'bodyweight', null, true, 90, '1. Balance on one leg before box.
2. Jump onto box from single leg.
3. Land softly on same leg.
4. Step down carefully.'),
  ('slam_ball', 'Slam Ball', 'core', array['shoulders','back']::muscle_group[], 'none', null, false, 45, '1. Hold slam ball overhead.
2. Slam down with maximum force.
3. Pick up or catch.
4. Repeat.'),
  ('broad_jump_reactive', 'Reactive Broad Jump', 'legs', array['glutes']::muscle_group[], 'bodyweight', null, false, 90, '1. Jump forward as far as possible.
2. On landing, immediately jump again.
3. Three consecutive jumps.
4. Measure total distance.'),
  ('seated_box_jump', 'Seated Box Jump', 'legs', array['glutes']::muscle_group[], 'bodyweight', null, false, 90, '1. Sit on bench facing box.
2. Without rocking, jump onto box from seated.
3. Land softly.
4. Step down.'),
  ('hurdle_hop_continuous', 'Hurdle Hop (Continuous)', 'legs', '{}'::muscle_group[], 'bodyweight', null, false, 60, '1. Set several hurdles in a row.
2. Jump over each in succession.
3. Minimize ground contact time.
4. Land and go immediately.'),
  ('wall_handstand_hold', 'Wall Handstand Hold', 'shoulders', array['core','triceps']::muscle_group[], 'bodyweight', 'static', false, 90, '1. Face wall, place hands 6 inches from base.
2. Kick up into handstand.
3. Press through shoulders, keep core tight.
4. Hold.'),
  ('pike_push_up_elevated', 'Pike Push-Up (Elevated)', 'shoulders', array['triceps']::muscle_group[], 'bodyweight', 'push_vertical', false, 60, '1. Place feet on bench, hands on floor.
2. Hips high, body in V shape.
3. Lower head toward floor.
4. Press back up.'),
  ('handstand_push_up_wall_negative', 'Handstand Push-Up Negative', 'shoulders', array['triceps','core']::muscle_group[], 'bodyweight', 'push_vertical', false, 90, '1. Kick up to wall handstand.
2. Slowly lower head to floor over 5 seconds.
3. Control descent fully.
4. Return to start.'),
  ('one_arm_push_up_knee', 'One Arm Push-Up (Kneeling)', 'chest', array['triceps']::muscle_group[], 'bodyweight', 'push_horizontal', true, 60, '1. Kneel, place one hand on floor.
2. Lower chest to floor.
3. Press back up with one arm.
4. Switch sides.'),
  ('archer_pull_up', 'Archer Pull-Up', 'back', array['biceps']::muscle_group[], 'bodyweight', 'pull_vertical', true, 90, '1. Grip bar wide.
2. Pull up to one side, keeping other arm straight.
3. Alternate sides each rep.
4. Focus on unilateral strength.'),
  ('typewriter_push_up', 'Typewriter Push-Up', 'chest', array['triceps','back']::muscle_group[], 'bodyweight', 'push_horizontal', false, 60, '1. Lower into push-up.
2. At bottom, shift weight to one side.
3. Travel across to other side horizontally.
4. Press back up.'),
  ('l_sit_progression_tuck', 'L-Sit Tuck Hold', 'core', array['triceps','shoulders']::muscle_group[], 'bodyweight', 'static', false, 60, '1. Support on parallettes or dip bars.
2. Lift knees to chest (tuck position).
3. Hold hips off ground.
4. Progress toward extended L-sit.'),
  ('muscle_up_negative', 'Muscle-Up Negative', 'back', array['chest','triceps']::muscle_group[], 'bodyweight', 'pull_vertical', false, 90, '1. Start at top of muscle-up position.
2. Slowly lower through the transition.
3. Descend into dead hang.
4. Return to start.'),
  ('skin_the_cat', 'Skin the Cat', 'back', array['core','shoulders']::muscle_group[], 'bodyweight', 'pull_vertical', false, 60, '1. Hang from bar or rings.
2. Tuck legs and rotate backward through arms.
3. Extend into German hang position.
4. Reverse back through.'),
  ('front_lever_tuck', 'Front Lever (Tuck)', 'back', array['core','shoulders']::muscle_group[], 'bodyweight', 'static', false, 90, '1. Hang from bar.
2. Pull body horizontal with knees tucked.
3. Keep arms straight, hips level.
4. Hold position.'),
  ('planche_lean', 'Planche Lean', 'shoulders', array['core','chest']::muscle_group[], 'bodyweight', 'static', false, 90, '1. In push-up position on straight arms.
2. Lean forward until shoulders are ahead of hands.
3. Hold with maximum lean.
4. Builds strength for planche.'),
  ('frog_stand', 'Frog Stand', 'core', array['shoulders','triceps']::muscle_group[], 'bodyweight', 'static', false, 60, '1. Squat down, hands on floor.
2. Place inner knees on backs of upper arms.
3. Shift weight to hands and lift feet.
4. Hold balance.'),
  ('negative_pull_up', 'Negative Pull-Up', 'back', array['biceps']::muscle_group[], 'bodyweight', 'pull_vertical', false, 90, '1. Start at top of pull-up.
2. Lower yourself slowly over 5 seconds.
3. Control descent fully.
4. Return to top.'),
  ('ring_push_up', 'Ring Push-Up', 'chest', array['triceps','core']::muscle_group[], 'bodyweight', 'push_horizontal', false, 60, '1. Set rings at knee height.
2. Grip rings in push-up position.
3. Lower chest to rings, keeping core rigid.
4. Press up, rotating rings outward.'),
  ('hollow_rock', 'Hollow Rock', 'core', '{}'::muscle_group[], 'bodyweight', 'static', false, 45, '1. Lie on back, arms overhead.
2. Brace core into hollow body position.
3. Rock forward and back without losing position.
4. Keep lower back pressed down.'),
  ('arch_body_hold', 'Arch Body Hold', 'back', array['glutes']::muscle_group[], 'bodyweight', 'static', false, 60, '1. Lie face down, arms overhead.
2. Lift arms, chest, and legs off floor simultaneously.
3. Keep neck neutral.
4. Hold position.'),
  ('bar_dip', 'Bar Dip', 'triceps', array['chest','shoulders']::muscle_group[], 'bodyweight', 'push_vertical', false, 90, '1. Support body on parallel bars.
2. Lower until shoulders dip below elbows.
3. Press back up.
4. Lean forward for chest emphasis.'),
  ('push_up_spiderman', 'Spiderman Push-Up', 'chest', array['core','triceps']::muscle_group[], 'bodyweight', 'push_horizontal', false, 60, '1. In push-up position.
2. As you lower, bring one knee to outside elbow.
3. Press back up and return leg.
4. Alternate sides.'),
  ('chest_to_bar_pull_up', 'Chest-to-Bar Pull-Up', 'back', array['biceps']::muscle_group[], 'bodyweight', 'pull_vertical', false, 90, '1. Dead hang from bar.
2. Pull explosively until chest touches bar.
3. Lower with control.
4. Full dead hang at bottom.'),
  ('explosive_pull_up', 'Explosive Pull-Up', 'back', array['biceps']::muscle_group[], 'bodyweight', 'pull_vertical', false, 90, '1. Dead hang on bar.
2. Explode upward as fast as possible.
3. Aim to release bar at top.
4. Catch and lower.'),
  ('korean_dip', 'Korean Dip', 'chest', array['triceps','shoulders']::muscle_group[], 'bodyweight', 'push_horizontal', false, 90, '1. Hold bar behind you, arms straight.
2. Lower body between arms.
3. Keep elbows pointing back.
4. Press back up.'),
  ('dead_hang', 'Dead Hang', 'back', array['shoulders']::muscle_group[], 'bodyweight', 'static', false, 60, '1. Grip bar with both hands.
2. Release weight from feet.
3. Hang fully, shoulders in sockets.
4. Hold for time.'),
  ('active_hang', 'Active Hang', 'back', array['shoulders']::muscle_group[], 'bodyweight', 'static', false, 60, '1. Grip bar, hang with arms extended.
2. Engage shoulder blades pulling them down.
3. Keep core braced.
4. Hold while breathing.'),
  ('one_arm_hang', 'One Arm Hang', 'back', array['shoulders']::muscle_group[], 'bodyweight', 'static', true, 90, '1. Grip bar with one hand.
2. Hang with other arm to side.
3. Engage shoulder and lat.
4. Hold for time.'),
  ('ab_wheel_kneeling', 'Ab Wheel (Kneeling)', 'core', array['shoulders','back']::muscle_group[], 'none', 'static', false, 60, '1. Kneel with ab wheel on floor.
2. Roll forward until torso near floor.
3. Brace core throughout.
4. Roll back to start.'),
  ('cable_woodchop_horizontal', 'Cable Wood Chop (Horizontal)', 'core', array['shoulders']::muscle_group[], 'cable', 'rotation', true, 60, '1. Set cable at mid-chest height.
2. Stand sideways, grip handle.
3. Rotate torso horizontally.
4. Return with control.'),
  ('landmine_rotation_core', 'Landmine Rotation', 'core', array['shoulders']::muscle_group[], 'barbell', 'rotation', false, 60, '1. Hold barbell end overhead, barbell in landmine.
2. Rotate arms in arc from side to side.
3. Control the weight at each end.
4. Keep core braced.'),
  ('plank_shoulder_tap', 'Plank Shoulder Tap', 'core', array['shoulders']::muscle_group[], 'bodyweight', 'static', false, 30, '1. High plank position.
2. Lift one hand, tap opposite shoulder.
3. Replace and repeat on other side.
4. Minimize hip rotation.'),
  ('plank_up_down', 'Plank Up-Down', 'core', array['triceps','shoulders']::muscle_group[], 'bodyweight', 'static', false, 45, '1. Start in high plank.
2. Lower one arm to elbow.
3. Lower other arm.
4. Press back up one arm at a time.'),
  ('suitcase_deadlift', 'Suitcase Deadlift', 'core', array['back','legs']::muscle_group[], 'dumbbell', 'hinge', true, 90, '1. Place weight at side.
2. Hinge to grip, keep spine neutral.
3. Stand up, resisting lateral tilt.
4. Lower with control.'),
  ('oblique_crunch', 'Oblique Crunch', 'core', '{}'::muscle_group[], 'bodyweight', 'rotation', true, 45, '1. Lie on back, knees bent.
2. Place hand behind head.
3. Crunch up and rotate elbow toward opposite knee.
4. Lower and repeat.'),
  ('v_up_weighted', 'V-Up (Weighted)', 'core', '{}'::muscle_group[], 'dumbbell', 'pull_vertical', false, 60, '1. Lie flat, hold weight overhead.
2. Raise arms and legs simultaneously.
3. Hands meet feet at top.
4. Lower with control.'),
  ('copenhagen_plank', 'Copenhagen Plank', 'core', array['legs']::muscle_group[], 'bodyweight', 'static', true, 60, '1. Top foot on bench in side plank.
2. Bottom leg can rest on bench or hover.
3. Hold side plank with hip elevated.
4. Hold for time.'),
  ('dead_bug_alternating', 'Dead Bug (Alternating)', 'core', '{}'::muscle_group[], 'bodyweight', 'static', false, 30, '1. Lie on back, arms up, hips and knees at 90 degrees.
2. Extend opposite arm and leg toward floor.
3. Return and switch.
4. Keep lower back flat.'),
  ('pallof_press_rotation', 'Pallof Press with Rotation', 'core', array['shoulders']::muscle_group[], 'cable', 'rotation', false, 60, '1. Set cable at chest height, stand perpendicular.
2. Hold handle at chest.
3. Press forward, rotate to face machine.
4. Return to center and bring in.'),
  ('stir_the_pot', 'Stir the Pot', 'core', array['shoulders']::muscle_group[], 'none', 'rotation', false, 60, '1. Forearms on stability ball in plank.
2. Move forearms in small circles.
3. Keep hips level, core rigid.
4. Alternate directions.'),
  ('single_leg_plank', 'Single Leg Plank', 'core', array['glutes']::muscle_group[], 'bodyweight', 'static', true, 45, '1. Forearm plank position.
2. Lift one leg off floor.
3. Hold without rotating hips.
4. Switch legs.'),
  ('wipers_hanging', 'Hanging Windshield Wipers', 'core', array['back']::muscle_group[], 'bodyweight', 'rotation', false, 60, '1. Hang from bar, raise legs to horizontal.
2. Rotate legs side to side.
3. Control the arc.
4. Avoid swinging.'),
  ('reverse_crunch', 'Reverse Crunch', 'core', '{}'::muscle_group[], 'bodyweight', 'pull_vertical', false, 45, '1. Lie on back, knees bent.
2. Pull knees toward chest, lifting hips.
3. Curl lower spine up.
4. Lower with control.'),
  ('cable_crunch_side', 'Side Cable Crunch', 'core', '{}'::muscle_group[], 'cable', 'rotation', true, 60, '1. Set high cable, stand sideways.
2. Hold rope on near side.
3. Crunch laterally toward hip.
4. Return with control.'),
  ('glute_bridge_march', 'Glute Bridge March', 'core', array['glutes']::muscle_group[], 'bodyweight', 'hinge', false, 30, '1. Lie in glute bridge position.
2. Hold hips up, march knees to chest alternately.
3. Keep hips level.
4. Maintain tension throughout.'),
  ('bear_crawl', 'Bear Crawl', 'core', array['shoulders','legs']::muscle_group[], 'bodyweight', 'carry', false, 45, '1. Hands and toes, knees hovering 2 inches off ground.
2. Move opposite hand and foot forward.
3. Maintain flat back.
4. Travel forward or in place.'),
  ('tuck_hold', 'Tuck Hold (Hanging)', 'core', array['back']::muscle_group[], 'bodyweight', 'static', false, 60, '1. Hang from bar.
2. Pull knees to chest.
3. Hold tucked position.
4. Lower slowly.'),
  ('cable_torso_rotation', 'Cable Torso Rotation', 'core', '{}'::muscle_group[], 'cable', 'rotation', true, 60, '1. Set cable at shoulder height.
2. Stand sideways, grip handle with both hands.
3. Rotate away from machine.
4. Control the return.'),
  ('suitcase_deadlift_barbell', 'Suitcase Deadlift (Barbell)', 'core', array['back','legs']::muscle_group[], 'barbell', 'hinge', true, 90, '1. Barbell on floor at side.
2. Grip center, pull to stand without lateral tilt.
3. Resist side-bend throughout.
4. Lower with control.'),
  ('hang_power_clean', 'Hang Power Clean', 'back', array['legs','shoulders']::muscle_group[], 'barbell', 'hinge', false, 120, '1. Start with bar at hip crease.
2. Dip and drive explosively, shrug shoulders.
3. Pull elbows high and around.
4. Catch in partial squat.'),
  ('power_clean', 'Power Clean', 'back', array['legs','shoulders','core']::muscle_group[], 'barbell', 'hinge', false, 120, '1. Start with bar on floor.
2. Pull to hip, dip and explode.
3. Shrug and pull elbows high.
4. Catch above parallel squat.'),
  ('clean_pull', 'Clean Pull', 'back', array['legs']::muscle_group[], 'barbell', 'hinge', false, 120, '1. Set up as if for full clean.
2. Pull bar from floor with full extension.
3. Shrug at top without catching.
4. Lower with control.'),
  ('snatch_pull', 'Snatch Pull', 'back', array['legs']::muscle_group[], 'barbell', 'hinge', false, 120, '1. Wide grip on bar.
2. Pull from floor, extend fully.
3. Shrug at top.
4. Lower to start.'),
  ('power_snatch', 'Power Snatch', 'back', array['legs','shoulders']::muscle_group[], 'barbell', 'hinge', false, 120, '1. Wide snatch grip, bar on floor.
2. Pull to hip, explode up.
3. Receive bar overhead above parallel.
4. Stabilize and stand.'),
  ('thruster', 'Thruster', 'legs', array['shoulders','core']::muscle_group[], 'barbell', 'squat', false, 90, '1. Bar in front rack, squat to depth.
2. Drive up explosively.
3. Use momentum to press bar overhead.
4. Lock out and lower to rack.'),
  ('thruster_dumbbell', 'Dumbbell Thruster', 'legs', array['shoulders']::muscle_group[], 'dumbbell', 'squat', false, 90, '1. Hold dumbbells at shoulders.
2. Squat to depth.
3. Drive up and press overhead.
4. Lower and repeat.'),
  ('split_jerk', 'Split Jerk', 'shoulders', array['legs','triceps']::muscle_group[], 'barbell', 'push_vertical', false, 120, '1. Bar in front rack.
2. Dip and drive explosively.
3. Split legs front and back.
4. Lock bar overhead, recover feet.'),
  ('hang_clean', 'Hang Clean', 'back', array['legs','shoulders']::muscle_group[], 'barbell', 'hinge', false, 120, '1. Hold bar at hip with clean grip.
2. Dip and drive, shrug.
3. Pull elbows fast into catch.
4. Receive in squat and stand.'),
  ('clean_deadlift', 'Clean Deadlift', 'back', array['legs']::muscle_group[], 'barbell', 'hinge', false, 120, '1. Clean grip, bar on floor.
2. Pull as for clean but controlled.
3. Full extension at top.
4. Lower with control.'),
  ('push_press_dumbbell', 'Push Press (Dumbbell)', 'shoulders', array['triceps','legs']::muscle_group[], 'dumbbell', 'push_vertical', false, 90, '1. Hold dumbbells at shoulders.
2. Dip with knees.
3. Drive upward and press overhead.
4. Lower slowly.'),
  ('snatch_balance', 'Snatch Balance', 'shoulders', array['legs','core']::muscle_group[], 'barbell', 'squat', false, 120, '1. Bar behind neck in wide grip.
2. Dip and drive bar up.
3. Drop under into overhead squat.
4. Stand with bar locked.'),
  ('hang_high_pull', 'Hang High Pull', 'back', array['shoulders','legs']::muscle_group[], 'barbell', 'hinge', false, 90, '1. Bar at hip in clean grip.
2. Drive up, shrug, and pull elbows high.
3. Bar rises to chin level.
4. Lower with control.'),
  ('behind_neck_press_barbell', 'Behind the Neck Press (Barbell)', 'shoulders', array['triceps']::muscle_group[], 'barbell', 'push_vertical', false, 90, '1. Bar resting behind neck on traps.
2. Press straight up to lockout.
3. Lower behind neck.
4. Keep core braced throughout.'),
  ('farmer_carry_barbell', 'Farmer Carry (Barbell)', 'core', array['shoulders','back']::muscle_group[], 'barbell', 'carry', false, 90, '1. Hold barbell in each hand.
2. Stand tall, brace core.
3. Walk with controlled steps.
4. Cover target distance.'),
  ('farmer_carry_kettlebell', 'Farmer Carry (Kettlebell)', 'core', array['shoulders']::muscle_group[], 'kettlebell', 'carry', false, 90, '1. Hold kettlebell in each hand.
2. Walk upright with controlled steps.
3. Keep shoulders back.
4. Cover target distance.'),
  ('yoke_carry', 'Yoke Carry', 'core', array['back','legs']::muscle_group[], 'none', 'carry', false, 120, '1. Position yoke across upper back.
2. Lift and walk quickly.
3. Keep steps short and fast.
4. Cover target distance.'),
  ('sled_pull_rope', 'Sled Pull (Rope)', 'back', array['biceps','core']::muscle_group[], 'none', 'pull_horizontal', false, 90, '1. Attach rope to sled.
2. Sit or stand, pull rope hand-over-hand.
3. Keep elbows low.
4. Pull to target distance.'),
  ('bear_crawl_weighted', 'Bear Crawl (Weighted)', 'core', array['shoulders']::muscle_group[], 'none', 'carry', false, 60, '1. Wear weighted vest.
2. Crawl with hands and toes.
3. Knees hover 2 inches off ground.
4. Cover target distance.'),
  ('sandbag_carry', 'Sandbag Carry', 'core', array['back','shoulders']::muscle_group[], 'none', 'carry', false, 90, '1. Pick up sandbag, hold at chest or over shoulder.
2. Walk with controlled pace.
3. Brace core throughout.
4. Cover target distance.'),
  ('wrist_curl_dumbbell', 'Wrist Curl (Dumbbell)', 'shoulders', '{}'::muscle_group[], 'dumbbell', 'static', true, 30, '1. Rest forearm on bench, wrist hanging off.
2. Hold dumbbell, curl wrist upward.
3. Squeeze at top.
4. Lower fully.'),
  ('wrist_curl_behind_back_barbell', 'Behind-the-Back Wrist Curl', 'shoulders', '{}'::muscle_group[], 'barbell', 'static', false, 30, '1. Hold barbell behind back.
2. Let bar roll to fingertips.
3. Curl wrist upward.
4. Control descent.'),
  ('reverse_wrist_curl_dumbbell', 'Reverse Wrist Curl (Dumbbell)', 'shoulders', '{}'::muscle_group[], 'dumbbell', 'static', true, 30, '1. Forearm on bench, palm facing down.
2. Hold dumbbell, extend wrist upward.
3. Hold briefly.
4. Lower with control.'),
  ('plate_pinch', 'Plate Pinch', 'shoulders', array['shoulders']::muscle_group[], 'none', 'static', true, 60, '1. Pinch weight plate between fingers and thumb.
2. Hold at side.
3. Maintain grip as long as possible.
4. Set down.'),
  ('bar_hang_single_arm_timed', 'Single Arm Bar Hang (Timed)', 'back', array['shoulders']::muscle_group[], 'bodyweight', 'static', true, 90, '1. Grip bar with one hand.
2. Release other hand.
3. Hang for time.
4. Aim to beat previous record.'),
  ('towel_pull_up', 'Towel Pull-Up', 'back', array['shoulders','biceps']::muscle_group[], 'bodyweight', 'pull_vertical', false, 90, '1. Drape towels over bar.
2. Grip towels.
3. Pull up to chin level.
4. Lower with control.'),
  ('wrist_roller', 'Wrist Roller', 'shoulders', array['shoulders']::muscle_group[], 'none', 'static', false, 60, '1. Hold wrist roller at arm length.
2. Roll weight up by wrist extension.
3. Unroll slowly.
4. Repeat in opposite direction.'),
  ('farmers_carry_single_arm', 'Farmer Carry (Single Arm)', 'core', array['shoulders']::muscle_group[], 'dumbbell', 'carry', true, 60, '1. Hold heavy weight in one hand.
2. Walk upright, resisting side bend.
3. Keep shoulder packed.
4. Switch arms at halfway.'),
  ('hex_hold', 'Hex Hold (Dumbbell)', 'shoulders', array['shoulders']::muscle_group[], 'dumbbell', 'static', false, 60, '1. Hold two hex dumbbells at sides.
2. Arms straight.
3. Hold for target time.
4. Builds grip and shoulder stability.'),
  ('rice_bucket_exercise', 'Rice Bucket Exercise', 'shoulders', array['shoulders']::muscle_group[], 'none', 'static', false, 30, '1. Fill bucket with rice.
2. Submerge hands.
3. Open and close fists, twist, and rotate.
4. Continue for set time.'),
  ('cable_kneeling_crunch_oblique', 'Kneeling Cable Oblique Crunch', 'core', '{}'::muscle_group[], 'cable', 'rotation', true, 60, '1. Kneel sideways to high cable.
2. Hold rope on same side as cable.
3. Crunch laterally downward.
4. Return slowly.'),
  ('cable_ab_pull_down', 'Cable Ab Pull Down', 'core', '{}'::muscle_group[], 'cable', 'pull_vertical', false, 60, '1. Kneel under high cable, grip rope behind head.
2. Contract abs and pull elbows toward knees.
3. Hold briefly at bottom.
4. Return slowly.'),
  ('cable_decline_fly_low', 'Cable Decline Fly (Low)', 'chest', '{}'::muscle_group[], 'cable', 'push_horizontal', false, 60, '1. Set cables high, lie on decline bench.
2. Arc handles together below chest.
3. Squeeze pecs.
4. Return with control.'),
  ('cable_standing_row_wide', 'Cable Standing Row (Wide)', 'back', array['shoulders']::muscle_group[], 'cable', 'pull_horizontal', false, 90, '1. Set cable at chest height with wide bar.
2. Step back, grip wide.
3. Row bar to chest, flaring elbows.
4. Return with control.'),
  ('cable_hip_thrust_bilateral', 'Cable Hip Thrust (Bilateral)', 'glutes', array['legs']::muscle_group[], 'cable', 'hinge', false, 90, '1. Face away from cable, rope around waist.
2. Hinge forward at hips.
3. Drive hips forward to standing.
4. Squeeze glutes at top.'),
  ('dumbbell_upright_row', 'Dumbbell Upright Row', 'shoulders', array['biceps']::muscle_group[], 'dumbbell', 'pull_vertical', false, 60, '1. Stand, hold dumbbells in front.
2. Pull elbows high, raising dumbbells to chin.
3. Keep weights close to body.
4. Lower with control.'),
  ('ez_bar_overhead_extension', 'EZ-Bar Overhead Extension', 'triceps', '{}'::muscle_group[], 'barbell', 'push_vertical', false, 60, '1. Hold EZ-bar overhead, narrow grip.
2. Lower behind head by bending elbows.
3. Extend back to lockout.
4. Control the descent.'),
  ('kettlebell_sumo_deadlift', 'Kettlebell Sumo Deadlift', 'legs', array['glutes','back']::muscle_group[], 'kettlebell', 'hinge', false, 90, '1. Wide stance over kettlebell.
2. Grip handle, spine neutral.
3. Drive through heels to stand.
4. Lower with control.'),
  ('resistance_band_face_pull', 'Resistance Band Face Pull', 'shoulders', array['back']::muscle_group[], 'resistance_band', 'pull_horizontal', false, 30, '1. Anchor band at face height.
2. Grip ends with pronated hands.
3. Pull to face, elbows flaring high.
4. Squeeze rear delts and return.'),
  ('resistance_band_lateral_walk', 'Resistance Band Lateral Walk', 'glutes', array['legs']::muscle_group[], 'resistance_band', 'static', false, 30, '1. Place band around ankles.
2. Quarter squat position.
3. Step laterally, keeping tension on band.
4. Walk set distance each direction.'),
  ('resistance_band_pallof_press', 'Resistance Band Pallof Press', 'core', '{}'::muscle_group[], 'resistance_band', 'static', false, 60, '1. Anchor band at chest height.
2. Stand perpendicular, hold band at chest.
3. Press forward, resisting rotation.
4. Hold and return.'),
  ('prowler_pull', 'Prowler Pull', 'back', array['legs','biceps']::muscle_group[], 'none', 'pull_horizontal', false, 90, '1. Attach rope to loaded prowler.
2. Walk backward pulling prowler.
3. Drive heels down, lean back slightly.
4. Cover target distance.'),
  ('trap_bar_carry', 'Trap Bar Carry', 'core', array['legs','shoulders']::muscle_group[], 'barbell', 'carry', false, 90, '1. Load trap bar, step inside.
2. Pick up with neutral grip.
3. Walk upright for distance.
4. Lower with control.'),
  ('db_lateral_raise_seated', 'Lateral Raise Seated (Dumbbell)', 'shoulders', '{}'::muscle_group[], 'dumbbell', 'push_horizontal', false, 60, '1. Sit on end of bench, dumbbells at sides.
2. Raise arms to shoulder height.
3. Hold briefly.
4. Lower with control.'),
  ('incline_rear_delt_fly', 'Incline Rear Delt Fly', 'shoulders', array['back']::muscle_group[], 'dumbbell', 'pull_horizontal', false, 60, '1. Lie chest down on incline bench.
2. Raise dumbbells out to sides, squeezing rear delts.
3. Hold briefly.
4. Lower with control.'),
  ('trap_bar_overhead_press', 'Trap Bar Overhead Press', 'shoulders', array['triceps']::muscle_group[], 'barbell', 'push_vertical', false, 90, '1. Stand inside trap bar, grip handles.
2. Clean bar to shoulder height.
3. Press overhead to lockout.
4. Lower to shoulders.'),
  ('wall_ball_squat_throw', 'Wall Ball (Squat Throw)', 'legs', array['shoulders','core']::muscle_group[], 'none', 'squat', false, 45, '1. Hold medicine ball at chest.
2. Squat to full depth.
3. Drive up explosively, throw ball to target.
4. Catch and repeat.'),
  ('landmine_deadlift', 'Landmine Deadlift', 'back', array['legs','glutes']::muscle_group[], 'barbell', 'hinge', false, 90, '1. Load barbell in landmine.
2. Stand over end, grip with both hands.
3. Drive to standing.
4. Lower with control.'),
  ('landmine_goblet_squat', 'Landmine Goblet Squat', 'legs', array['glutes','core']::muscle_group[], 'barbell', 'squat', false, 90, '1. Hold barbell end at chest in goblet position.
2. Squat to full depth.
3. Drive through heels to stand.
4. Maintain upright torso.'),
  ('resistance_band_good_morning', 'Resistance Band Good Morning', 'back', array['legs']::muscle_group[], 'resistance_band', 'hinge', false, 60, '1. Stand on band, loop over shoulders.
2. Hinge forward at hips, back flat.
3. Feel hamstring stretch.
4. Return to standing.');
