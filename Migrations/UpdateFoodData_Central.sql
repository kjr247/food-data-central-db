-- go to SQL Server -> Query -> SQLCMD Mode

use FoodData_Central;
:setvar path "C:\Users\kjr24\source\repos\MineralMateAPI\Scripts\Migrations\DDLs\"

:r $(path)Update_acquisition_sample.sql
:r $(path)Update_agricultural_acquisition.sql
:r $(path)Update_branded_food.sql
:r $(path)Update_fndds_derivation.sql
:r $(path)Update_fndds_ingredient_nutrient_value.sql
:r $(path)Update_food.sql
:r $(path)Update_food_attribute.sql
:r $(path)Update_food_attribute_type.sql
:r $(path)Update_food_calorie_conversion_factor.sql
:r $(path)Update_food_category.sql
:r $(path)Update_food_component.sql
--:r $(path)Update_food_nutrient.sql
:r $(path)Update_food_nutrient_conversion_factor.sql
:r $(path)Update_food_nutrient_derivation.sql
:r $(path)Update_food_nutrient_source.sql
:r $(path)Update_food_portion.sql
:r $(path)Update_food_protein_conversion_factor.sql
:r $(path)Update_foundation_food.sql
:r $(path)Update_input_food.sql
:r $(path)Update_lab_method.sql
:r $(path)Update_lab_method_code.sql
:r $(path)Update_lab_method_nutrient.sql
:r $(path)Update_market_acquisition.sql
:r $(path)Update_nutrient.sql
:r $(path)Update_nutrient_incoming_name.sql
:r $(path)Update_retention_factor.sql
:r $(path)Update_sample_food.sql
:r $(path)Update_sr_legacy_food.sql
:r $(path)Update_sub_sample_food.sql
:r $(path)Update_sub_sample_result.sql
:r $(path)Update_survey_fndds_food.sql
:r $(path)Update_measure_unit.sql
:r $(path)Update_wweia_food_category.sql