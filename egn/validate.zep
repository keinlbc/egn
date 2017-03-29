namespace Egn;

class Validate
{

	protected egn {
		get, set, toString
	};

	protected birthDay{
		get,set
	};

	protected birthMonth{
		get,set
	};

	protected birthYear{
		get,set
	};
	protected region{
		get
	};
	protected isMale {
		get,set
	};

	protected isFemale{
		get,set
	};

	private parity_weights = [2,4,8,5,10,9,7,3,6];

	private static regions = [ 		
			"Благоевград"       : 43,  /* от 000 до 043 */ 		
			"Бургас"            : 93,  /* от 044 до 093 */ 		
			"Варна"             : 139, /* от 094 до 139 */ 		
			"Велико Търново"    : 169, /* от 140 до 169 */ 		
			"Видин"             : 183, /* от 170 до 183 */ 		
			"Враца"             : 217, /* от 184 до 217 */ 		
			"Габрово"           : 233, /* от 218 до 233 */ 		
			"Кърджали"          : 281, /* от 234 до 281 */ 		
			"Кюстендил"         : 301, /* от 282 до 301 */ 		
			"Ловеч"             : 319, /* от 302 до 319 */ 		
			"Монтана"           : 341, /* от 320 до 341 */ 		
			"Пазарджик"         : 377, /* от 342 до 377 */ 		
			"Перник"            : 395, /* от 378 до 395 */ 		
			"Плевен"            : 435, /* от 396 до 435 */ 		
			"Пловдив"           : 501, /* от 436 до 501 */ 		
			"Разград"           : 527, /* от 502 до 527 */ 		
			"Русе"              : 555, /* от 528 до 555 */ 		
			"Силистра"          : 575, /* от 556 до 575 */ 		
			"Сливен"            : 601, /* от 576 до 601 */ 		
			"Смолян"            : 623, /* от 602 до 623 */ 		
			"София-град"        : 721, /* от 624 до 721 */ 		
			"София-окръг"       : 751, /* от 722 до 751 */ 		
			"Стара Загора"      : 789, /* от 752 до 789 */ 		
			"Добрич"            : 821, /* от 790 до 821 */ 		
			"Търговище"         : 843, /* от 822 до 843 */ 		
			"Хасково"           : 871, /* от 844 до 871 */ 		
			"Шумен"             : 903, /* от 872 до 903 */ 		
			"Ямбол"             : 925, /* от 904 до 925 */ 		
			"Друг/Неизвестен"   : 999 /* от 926 до 999 */ 	
		];


	
	public function __construct(string egn) {




		if((int)egn < 1000000000 || (int)egn > 9999999999){
			throw new \Exception("Egn is must be a 10 digit number");
		}
		this->setEgn(egn);

		// // parity digit must be correct:
		if !this->isValid(){
			throw new \Exception("Parity check failed - invalid egn");
		}

		
		var year, month, day, sex;
		let year  = (int)substr(egn, 0, 2);
		let month = (int)substr(egn, 2, 2);
		let day   = (int)substr(egn, 4, 2);
		let sex   = (int)substr(egn, 8, 1);


		/**
		 * Month:
		 * 1-12 means year 19xx,
		 * 21-32 means year 18xx,
		 * 41-52 means year 20xx
		 */
		if month >= 1 && month <= 12 {
				let year += 1900;

		}elseif month >= 21 && month <= 32 {
				let year += 1800;
				let month -= 20;
		}elseif month >= 41 && month <= 52 {
				let year += 2000;
				let month -= 40;
		}else{
				throw new \Exception("Invalid month");
		}

		// must be valid date (i.e. not 30/Feb)
		if (!checkdate(month, day, year)) {
			throw new \Exception("Invalid birth date");
		}

		this->setBirthYear(year);
		this->setBirthMonth(month);
		this->setBirthDay(day);

		// // digit 9 (which translates to index 8) is even for males, odd for females
		this->setIsMale(sex%2 == 0); 
		this->setIsFemale(sex%2 != 0);


		// // // detect birth region
		$this->setRegion();
	}

	public function isValid() {
		var controlDigit = substr(this->egn, -1, 1);
		return this->getParityDigit() == controlDigit;
	}

	private function getParityDigit() {
		int sum = 0;
		var weight,number, index;
		for index, weight in this->parity_weights{
			let number = substr(this->egn, index, 1);
			let sum += number*weight;
		}
		return (int)(sum % 11) % 10;
	}
	private function setRegion(){
		var key, value;
		int num;
		let num = (int)substr(this->egn, 6, 3);
		for key, value in self::regions {
			if num <= value {
				let this->region = key;
				return;
			}
		}
	}
		
}