; MEDIMACROSADDON
;=============================================================================================================================================================
; Diccionario para MediMacros
;=============================================================================================================================================================

;##ESTRUCTURA DE LAS EXTENSIONES PARA MEDIMACROS##############################################################################################################
; El formato de las extensiones para mediMACROS es simplemente un script de AutoHotkey con algunas subrutinas predeterminadas que el script principal
; usa para agregar funcionalidad en el lugar correcto. Todas las subrutinas que estén en la plantilla para extensiones deben estar presentes aunque
; no se vayan a usar en la extensión que se esté creando.
; Si no se requiere alguna subrutina, se debe dejar el nombre y el elemento "return", de modo que el script continúe con su estructura.
;#############################################################################################################################################################

DictReadSettings: ;==Variables para configurar mediMACROS====================================================================================================
dict_Name :=					"Abreviaturas sin dosis"					; Nombre de la extensión, no debe usar caracteres especiales.
return																		; regresar

:R:DM2::Diabetes mellitus tipo 2
:R:DM1::Diabetes mellitus tipo 1
:R:AR::Artritis reumatoide
:R:SOP::Síndrome de ovario poliquístico
:R:EAD::Enfermedad articular degenerativa
:R:HPB::Hiperplasia prostática benigna
:R:ERC::Enfermedad renal crónica
:R:LUES::Lupus eritematoso sistémico
:R:ALZHEIMER::Enfermedad de alzheimer
:R:CUCI::Colitis ulcerosa crónica inespecífica
:R:CAMAMA::Cáncer de mama
:R:FA::Fibrilación auricular
:R:LABS::laboratorios
:R:PFH::pruebas de función hepática
:R:BH::biometría hemática
:R:QS::química sanguínea
:R:HBA1C::hemoglobina glucosilada
:R:VSG::velocidad de sedimentación globular
:R:MHD::medidas higiénico-dietéticas
:R:MTF::metformina
:R:ASA300::Acido acetilsalicílico soluble
:R:OMP::Omeprazol
:R:CLONA::Clonazepam
:R:FEXO::Fexofenadina
:R:PREGA::Pregabalina
:R:COMB::Complejo B
:R:LOSARTAN::Losartan
:R:MTP::Metoprolol
:R:HCTZ::Hidroclorotiazida
:R:DX::Diagnóstico
:R:PENTO::Pentoxifilina
:R:FURO::Furosemide
:R:TAMSU::Tamsulosina
:R:VILDA::Vildagliptina
:R:BEZA::Bezafibrato
:R:CLOPI::Clopidogrel
:R:TELMI::Telmisartan
:R:AMLO::Amlodipino
:R:PIOG::Pioglitazona
:R:BUPRE::Buprenorfina
:R:LEVOT::Levotiroxina
:R:ATOR::Atorvastatina
:R:TELMI::Telmisartan
:R:IRBE::Irbesartan
:R:SERTRA::Sertralina
:R:ENP::Enalapril
:R:Z125::Examen de pesquisa especial para tumor de la próstata
:R:Z131::Examen de pesquisa especial para diabetes mellitus
:R:FUM::fecha de última menstruación
:R:FPP::fecha probable de parto
:R:AFU::altura de fondo uterino
:R:FCF::frecuencia cardíaca fetal
:R:LPM::latidos por minuto
:R:SDG::semanas de gestación
:R:EGO::examen general de orina
:R:O098::Supervisión de embarazo de alto riesgo
:R:AOC::anticonceptivo oral combinado
:R:idx::impresión diagnóstica
:R:RX::radiografía
:R:PX::paciente
:R:DBP::diametro biparietal
:R:Z716::Consulta para asesoría por abuso de tabaco
:R:Z340::Contacto para supervisión del primer embarazo normal, trimestre no especificado 
:R:Z349::Contacto para supervisión del embarazo normal, no especificado, trimestre no especificado 
:R:PC::perímetro cefálico
:R:pa::perímetro abdominal
:R:lf::longitud femoral
:R:aprox::aproximadamente
:R:puvi::producto único vivo intrauterino
:R:HAS::Hipertensión esencial (primaria)
:R:O100::Hipertensión preexistente que complica el embarazo, parto y puerperio
:R:O139:: Hipertensión gestacional sin proteinuria significativa
:R:O095::Supervisión de multigrávida añosa
:R:rots::reflejos osteotendinosos
