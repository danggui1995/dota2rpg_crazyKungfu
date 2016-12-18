function walk_the_shadows_cast( event )
	local duration = event.duration
	event.ability:ApplyDataDrivenModifier(event.caster, event.caster, "modifier_yinsha_buff", nil)
	event.caster:AddNewModifier(event.caster, event.ability, "modifier_invisible", {duration = duration}) 

end

function walk_the_shadows_interrupt( event )
 event.caster:RemoveModifierByName("modifier_yinsha_buff")
 event.caster:RemoveModifierByName("modifier_invisible")
end

function walk_the_shadows_attack( event )

 event.caster:RemoveModifierByName("modifier_yinsha_buff")

 ApplyDamage({ victim = event.target, attacker = event.caster, damage = event.ability:GetAbilityDamage(), damage_type = event.ability:GetAbilityDamageType(), ability = event.ability   })

end