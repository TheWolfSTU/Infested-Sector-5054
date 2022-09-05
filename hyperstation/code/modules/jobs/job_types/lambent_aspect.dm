//I'll be honest I have no clue where to put lambent aspects, so this will just be here for now. I'm not the best at modularization, nor coding.
//This will be mostly commented out until I can sort out how this works. I preferably want to use an innate action, not a spell or anything attached to items.
//But it's proving to be difficult.

//Innate powers, without attuning to a specific aspect
/datum/action/innate/lambent
	name = "Dahl's a dumbass"
	desc = "Yell at her if you see this"

	background_icon_state = "bg_agent"

	icon_icon = 'icons/mob/actions/actions_spells.dmi' //Using this for now until I sprite some action buttons
	button_icon_state = "spell_default"

	check_flags = AB_CHECK_STUN|AB_CHECK_CONSCIOUS

	//cooldown_time = 10

/* Finish this when I understand the code a bit more
/datum/action/cooldown/lambent/locate
	name = "Weave Locate"
	desc = "Plunge into the weave to teleport to a target of your choosing. Be aware of your end result."
	button_icon_state = "emp"
	cooldown_time = 120

	/var/mob/living/carbon/human/target_human = target
*/

/datum/action/innate/lambent/dash
	name = "Surge Dash"
	desc = "Imbue yourself with weave energy to dash forwards."
	
	var/current_charges = 3
	var/max_charges = 3
	var/charge_rate = 250
	var/mob/living/carbon/human/holder

	var/dash_sound = 'sound/magic/blink.ogg'
	var/recharge_sound = 'sound/magic/charge.ogg'

	var/phasein = /obj/effect/temp_visual/dir_setting/ninja/phase
	var/phaseout = /obj/effect/temp_visual/dir_setting/ninja/phase/out
	var/beam_effect = "blur"

/datum/action/innate/lambent/dash/Grant(mob/user)
	. = ..()
	holder = user

/datum/action/innate/lambent/dash/IsAvailable()
	if(current_charges > 0)
		return TRUE
	else
		return FALSE

/datum/action/innate/lambent/dash/proc/Teleport(mob/user, atom/target)
	if(!IsAvailable())
		return
	var/turf/T = get_turf(target)
	if(target in view(user.client.view, user))
		var/obj/spot1 = new phaseout(get_turf(user), user.dir)
		user.forceMove(T)
		playsound(T, dash_sound, 25, 1)
		var/obj/spot2 = new phasein(get_turf(user), user.dir)
		spot1.Beam(spot2,beam_effect,time=20)
		current_charges--
		holder.update_action_buttons_icon()
		addtimer(CALLBACK(src, .proc/charge), charge_rate)

/datum/action/innate/lambent/dash/proc/charge()
	current_charges = CLAMP(current_charges + 1, 0, max_charges)
	holder.update_action_buttons_icon()
	if(recharge_sound)
		playsound(src, recharge_sound, 50, 1)
	to_chat(holder, "<span class='notice'>[src] now has [current_charges]/[max_charges] charges.</span>")

