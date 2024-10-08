﻿#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВладелецСвойств = Параметры.СсылкаНаОбъект;
	СписокСвойств.ЗагрузитьЗначения(Параметры.СвойстваОбъекта);
		
	ВывестиПоляДополнительныхСвойствНаФорму();
	ЗаполнитьРеквизитыДополнительныхСвойств();
	
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура Ок(Команда)
	
	ЗаписатьСвойства();
	ОповеститьОбИзменении(ВладелецСвойств);
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервере
Процедура ВывестиПоляДополнительныхСвойствНаФорму()
	
	СвойстваОбъекта = СписокСвойств.ВыгрузитьЗначения();
	РеквизитыСвойств = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(СвойстваОбъекта, "ИдентификаторДляФормул, ТипЗначения, Наименование, ВладелецДополнительныхЗначений");
	
	ДобавляемыеРеквизиты = Новый Массив;
	Для каждого Свойство Из СвойстваОбъекта Цикл
		
		Идентификатор = РеквизитыСвойств[Свойство].ИдентификаторДляФормул;
		ТипЗначения = РеквизитыСвойств[Свойство].ТипЗначения;
		НовыйРеквизит = Новый РеквизитФормы(Идентификатор, ТипЗначения);
		ДобавляемыеРеквизиты.Добавить(НовыйРеквизит);
		
	КонецЦикла;
	
	ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	
	Для каждого Свойство Из СвойстваОбъекта Цикл
		
		Идентификатор = РеквизитыСвойств[Свойство].ИдентификаторДляФормул;
		Наименование = РеквизитыСвойств[Свойство].Наименование;
		ВладелецДополнительныхЗначений = РеквизитыСвойств[Свойство].ВладелецДополнительныхЗначений;
		ТипЗначения = РеквизитыСвойств[Свойство].ТипЗначения;
		ЭтоДополнительноеЗначение = УправлениеСвойствамиСлужебный.ТипЗначенияСодержитЗначенияСвойств(ТипЗначения);
		Булево = ОбщегоНазначения.ОписаниеТипаСостоитИзТипа(ТипЗначения, Тип("Булево"));
		
		НовыйЭлемент = Элементы.Добавить(Идентификатор, Тип("ПолеФормы"), Элементы.ГруппаСвойства);
		НовыйЭлемент.ПутьКДанным = Идентификатор;
		НовыйЭлемент.Заголовок = Наименование;
		Если Булево Тогда
			НовыйЭлемент.Вид = ВидПоляФормы.ПолеФлажка;
			НовыйЭлемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Право;
		Иначе
			НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
			НовыйЭлемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
		КонецЕсли;
		
		Если ЭтоДополнительноеЗначение Тогда
			ПараметрыВыбора = Новый Массив;
			ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Владелец",
			?(ЗначениеЗаполнено(ВладелецДополнительныхЗначений),
			ВладелецДополнительныхЗначений, Свойство)));
			НовыйЭлемент.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбора);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыДополнительныхСвойств()
	
	ЗначенияСвойств = УправлениеСвойствами.ЗначенияСвойств(ВладелецСвойств);
	ИдентификаторыСвойств = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(Параметры.СвойстваОбъекта, "ИдентификаторДляФормул");
	
	Для каждого СтрокаСвойства Из ЗначенияСвойств Цикл
		Идентификатор = ИдентификаторыСвойств[СтрокаСвойства.Свойство];
		ЭтотОбъект[Идентификатор] = СтрокаСвойства.Значение;	
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьСвойства()
	
	СвойстваОбъекта = СписокСвойств.ВыгрузитьЗначения();

	ТаблицаСвойствИЗначений = Новый ТаблицаЗначений;
	ТаблицаСвойствИЗначений.Колонки.Добавить("Свойство");
	ТаблицаСвойствИЗначений.Колонки.Добавить("Значение");
	
	ОчищаемыеСвойства = Новый Массив;
	
	Идентификаторы = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(СвойстваОбъекта, "ИдентификаторДляФормул");
	
	Для каждого Свойство Из СвойстваОбъекта Цикл
		Идентификатор = Идентификаторы[Свойство];
		Значение = ЭтотОбъект[Идентификатор];
		Если ЗначениеЗаполнено(Значение) И Значение <> Ложь Тогда
			СтрокаСвойства = ТаблицаСвойствИЗначений.Добавить();
			СтрокаСвойства.Свойство = Свойство;
			СтрокаСвойства.Значение = ЭтотОбъект[Идентификатор];
		Иначе
			ОчищаемыеСвойства.Добавить(Свойство);
		КонецЕсли;
	КонецЦикла;
	
	Если ТаблицаСвойствИЗначений.Количество() > 0 Тогда
		УправлениеСвойствами.ЗаписатьСвойстваУОбъекта(ВладелецСвойств, ТаблицаСвойствИЗначений);
	КонецЕсли;
	
	Если ОчищаемыеСвойства.Количество() > 0 Тогда
		РеквизитФормыВЗначение("Объект").ОчиститьЗначенияСвойствОбъекта(ВладелецСвойств, ОчищаемыеСвойства);
	КонецЕсли;

КонецПроцедуры
#КонецОбласти


