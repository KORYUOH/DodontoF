#--*-coding:utf-8-*--

class MagicaLogia < DiceBot
  
  def initialize
    super
    @sendMode = 2;
    @sortType = 3;
    @d66Type = 2;
  end
  
  def gameName
    'マギカロギア'
  end
  
  def gameType
    "MagicaLogia"
  end
  
  def prefixs
     ['WT', 'FCT', 'ST', 'FT', 'AT', 'BGT', 'DAT', 'FAT', 'WIT', 'RTT', 'TPT', 'TCT', 'PCT', 'MCT', 'ICT', 'SCT', 'XCT', 'WCT', 'CCT', 'BST', 'PT', 'XEST', 'IWST', 'MCST', 'WDST', 'LWST',]
  end
  
  def getHelpMessage
    info = <<INFO_MESSAGE_TEXT
・各種表
変調表　　　　WT
運命変転表　　FCT
　典型的災厄 TCT／物理的災厄 PCT／精神的災厄 MCT／狂気的災厄 ICT
　社会的災厄 SCT／超常的災厄 XCT／不思議系災厄 WCT／コミカル系災厄 CCT
シーン表　　　ST
　極限環境 XEST／内面世界 IWST／魔法都市 MCST
　死後世界 WDST／迷宮世界 LWST
ファンブル表　FT
事件表　　　　AT
経歴表　　　　　BGT
初期アンカー表　DAT
運命属性表　　　FAT
願い表　　　　　WIT
ランダム特技表　RTT
時の流れ表　　　TPT
ブランク秘密表　BST
プライズ表　　　PT
・D66ダイスあり
INFO_MESSAGE_TEXT
  end
  
  
  def changeText(string)
    string
  end
  
  def dice_command(string, nick_e)
    secret_flg = false
    
    return '1', secret_flg unless( /(^|\s)(S)?(#{prefixs.join('|')})(\s|$)/i =~ string )
    
    secretMarker = $2
    command = $3

    @nick = nick_e
    output_msg = magicalogia_table(command, nick_e)
    if( secretMarker )    # 隠しロール
      secret_flg = true if(output_msg != '1');
    end
    
    return output_msg, secret_flg
  end
  
  def dice_command_xRn(string, nick_e)
    ''
  end
  
  def check_2D6(total_n, dice_n, signOfInequality, diff, dice_cnt, dice_max, n1, n_max)  # ゲーム別成功度判定(2D6)
    
    debug("total_n, dice_n, signOfInequality, diff, dice_cnt, dice_max, n1, n_max", total_n, dice_n, signOfInequality, diff, dice_cnt, dice_max, n1, n_max)
    
    return '' unless(signOfInequality == ">=")
    
    output = 
    if(dice_n <= 2)
      " ＞ ファンブル";
    elsif(dice_n >= 12)
      " ＞ スペシャル(魔力1D6点か変調1つ回復)";
    elsif(total_n >= diff)
      " ＞ 成功";
    else
      " ＞ 失敗";
    end
    
    output += getGainMagicElementText()
    
    return output
  end
  
  def check_nD6(total_n, dice_n, signOfInequality, diff, dice_cnt, dice_max, n1, n_max) # ゲーム別成功度判定(nD6)
    ''
  end
  
  def check_nD10(total_n, dice_n, signOfInequality, diff, dice_cnt, dice_max, n1, n_max)# ゲーム別成功度判定(nD10)
    ''
  end
  
  def check_1D10(total_n, dice_n, signOfInequality, diff, dice_cnt, dice_max, n1, n_max)     # ゲーム別成功度判定(1D10)
    ''
  end
  
  def check_1D100(total_n, dice_n, signOfInequality, diff, dice_cnt, dice_max, n1, n_max)    # ゲーム別成功度判定(1d100)
    ''
  end
  
  

####################          マギカロギア         ########################
#** 表振り分け
  def magicalogia_table(string, nick_e)
    output = '1';
    type = "";
    total_n = "";
    
    case string
    when 'BGT'
      type = '経歴表'
      output, total_n = magicalogia_background_table
    when 'DAT'
      type = '初期アンカー表'
      output, total_n = magicalogia_defaultanchor_table
    when 'FAT'
      type = '運命属性表'
      output, total_n = magicalogia_fortune_attribution_table
    when 'WIT'
      type = '願い表'
      output, total_n = magicalogia_wish_table
    when 'ST'
      type = 'シーン表'
      output, total_n = magicalogia_scene_table
    when 'FT'
      type = 'ファンブル表'
      output, total_n = magicalogia_fumble_table
    when 'WT'
      type = '変調表'
      output, total_n = magicalogia_wrong_table
    when 'FCT'
      type = '運命変転表'
      output, total_n = magicalogia_fortunechange_table
    when 'AT'
      type = '事件表'
      output, total_n = magicalogia_accident_table
    when 'RTT'
      type = 'ランダム特技決定表'
      output, total_n = magicalogia_random_skill_table
    when 'TPT'
      type = '時の流れ表'
      output, total_n = magicalogia_time_passage_table
    when 'TCT'
      type = '運命変転「典型的災厄」'
      output, total_n = magicalogia_typical_fortune_change_table
    when 'PCT'
      type = '運命変転「物理的災厄」'
      output, total_n = magicalogia_physical_fortune_change_table
    when 'MCT'
      type = '運命変転「精神的災厄」'
      output, total_n = magicalogia_mental_fortune_change_table
    when 'ICT'
      type = '運命変転「狂気的災厄」'
      output, total_n = magicalogia_insanity_fortune_change_table
    when 'SCT'
      type = '運命変転「社会的災厄」'
      output, total_n = magicalogia_social_fortune_change_table
    when 'XCT'
      type = '運命変転「超常的災厄」'
      output, total_n = magicalogia_paranormal_fortune_change_table
    when 'WCT'
      type = '運命変転「不思議系災厄」'
      output, total_n = magicalogia_wonderful_fortune_change_table
    when 'CCT'
      type = '運命変転「コミカル系災厄」'
      output, total_n = magicalogia_comical_fortune_change_table
    when 'BST'
      type = 'ブランク秘密表'
      output, total_n = magicalogia_blank_secret_table
    when 'PT'
      type = 'プライズ表'
      output, total_n = magicalogia_prise_table
    when 'XEST'
      type = '極限環境シーン表'
      output, total_n = magicalogia_extreme_environment_scene_table
    when 'IWST'
      type = '内面世界シーン表'
      output, total_n = magicalogia_innner_world_scene_table
    when 'MCST'
      type = '魔法都市シーン表'
      output, total_n = magicalogia_magic_city_scene_table
    when 'WDST'
      type = '死後世界シーン表'
      output, total_n = magicalogia_world_after_dead_scene_table
    when 'LWST'
      type = '迷宮世界シーン表'
      output, total_n = magicalogia_labyrinth_world_scene_table
    end
    
    return "#{nick_e}: #{type}(#{total_n}) ＞ #{output}";
  end

  #** シーン表
  def magicalogia_scene_table
    table = [
            '魔法で作り出した次元の狭間。ここは時間や空間から切り離された、どこでもあり、どこでもない場所だ。',
            '夢の中。遠く過ぎ去った日々が、あなたの前に現れる。',
            '静かなカフェの店内。珈琲の香りと共に、優しく穏やかな雰囲気が満ちている。',
            '強く風が吹き、雲が流されていく。遠く、雷鳴が聞こえた。どうやら、一雨きそうだ。',
            '無人の路地裏。ここならば、邪魔が入ることもないだろう。',
            lambda{return "周囲で〈断章〉が引き起こした魔法災厄が発生する。#{magicalogia_random_skill_table_text_only}の判定を行うこと。成功すると、好きな魔素が一個発生する。失敗すると「運命変転表」を使用する。"},
            '夜の街を歩く。暖かな家々の明かりが、遠く見える。',
            '読んでいた本を閉じる。そこには、あなたが知りたがっていたことが書かれていた。なるほど、そういうことか。',
            '大勢の人々が行き過ぎる雑踏の中。あなたを気に掛ける者は誰もいない。',
            '街のはるか上空。あなたは重力から解き放たれ、自由に空を飛ぶ。',
            '未来の予感。このままだと起きるかもしれない出来事の幻が現れる。',
            ]
    
    return get_table_by_2d6(table)
  end


#** ファンブル表
  def magicalogia_fumble_table
    table = [
        '魔法災厄が、あなたのアンカーに降りかかる。「運命変転」が発生する。',
        '魔法災厄が、あなたの魔素を奪い取る。チャージしている魔素の中から、好きな組み合わせで2点減少する。',
        '魔法の制御に失敗してしまう。【魔力】が1点減少する。',
        '魔法災厄になり、そのサイクルが終了するまで、行為判定にマイナス1の修正が付く。',
        '魔法災厄が、直接あなたに降りかかる。変調表を振り、その変調を受ける。',
        'ふぅ、危なかった。特に何も起こらない。',
            ]
    
    return get_table_by_1d6(table)
  end

#** 変調表
  def magicalogia_wrong_table
    table = [
            '『封印』自分の魔法(習得タイプが装備以外)からランダムに一つ選ぶ。選んだ魔法のチェック欄をチェックする。その魔法を使用するには【魔力】を2点消費しなくてはいけない。',
            '『綻び』魔法戦の間、各ラウンドの終了時に自分の【魔力】が1点減少する。',
            '『虚弱』【攻撃力】が1点減少する。',
            '『病魔』【防御力】が1点減少する。',
            '『遮蔽』【根源力】が1点減少する',
            lambda{return "『不運』#{magicalogia_random_skill_table_text_only}のチェック欄をチェックする。その特技が使用不能になり、その分野の特技が指定特技になった判定を行うとき、マイナス1の修正が付く。"},
             ]
    
    return get_table_by_1d6(table)
  end

  
#** 運命変転表
  def magicalogia_fortunechange_table
    table = [
             '『挫折』そのキャラクターは、自分にとって大切だった夢を諦める。',
             '『別離』そのキャラクターにとって大切な人――親友や恋人、親や兄弟などを失う。',
             '『大病』そのキャラクターは、不治の病を負う。',
             '『借金』そのキャラクターは、悪人に利用され多額の借金を負う。',
             '『不和』そのキャラクターは、人間関係に失敗し深い心の傷を負う。',
             '『事故』そのキャラクターは交通事故にあい、取り返しのつかない怪我を負う。',
            ]
    return get_table_by_1d6(table)
  end

#** 事件表
  def magicalogia_accident_table
    table = [
             '不意のプレゼント、素晴らしいアイデア、悪魔的な取引……あなたは好きな魔素を1つ獲得するか【魔力】を1D6点回復できる。どちらかを選んだ場合、その人物に対する【運命】が1点上昇する。【運命】の属性は、ゲームマスターが自由に決定できる。',
             '気高き犠牲、真摯な想い、圧倒的な力……その人物に対する【運命】が1点上昇する。【運命】の属性は「尊敬」になる。',
             '軽い口論、殴り合いの喧嘩、魔法戦……互いに1D6を振り、低い目を振った方が、高い目を振った方に対して【運命】が1点上昇する。【運命】の属性は「尊敬」になる。',
             '裏切り、策謀、不幸な誤解……その人物に対する【運命】が1点上昇する。【運命】の属性は「宿敵」になる。',
             '意図せぬ感謝、窮地からの救済、一生のお願いを叶える……その人物に対する【運命】が1点上昇する。【運命】の属性は「支配」になる。',
             lambda{return "生ける屍の群れ、地獄の業火、迷宮化……魔法災厄に襲われる。#{magicalogia_random_skill_table_text_only}の選んで判定を行う。失敗すると、その人物に対し「運命変転表」を使用する。"},
             '道路の曲がり角、コンビニ、空から落ちてくる……偶然出会う。その人物に対する【運命】が1点上昇する。【運命】の属性は「興味」になる。',
             '魂のひらめき、愛の告白、怪しい抱擁……その人物に対する【運命】が1点上昇する。【運命】の属性は「恋愛」になる。',
             '師弟関係、恋人同士、すれ違う想い……その人物との未来が垣間見える。たがいに対する【運命】が1点上昇する。',
             '懐かしい表情、大切な思い出、伴侶となる予感……その人物に対する【運命】が1点上昇する。【運命】の属性は「血縁」になる。',
             '献身的な看護、魔法的な祝福、奇跡……その人物に対する【運命】が1点上昇する。【運命】の属性は自由に決定できる。もしも関係欄に疵があれば、その疵を1つ関係欄から消すことができる。',
            ]
    
    return get_table_by_2d6(table)
  end
  
#** 魔素獲得チェック
  def getGainMagicElementText()
    diceList = getDiceList
    debug("getGainMagicElementText diceList", diceList)
    
    return '' if( diceList.empty? )

    dice1 = diceList[0]
    dice2 = diceList[1]
    
    #マギカロギア用魔素取得判定
    return  gainMagicElement(dice1, dice2);
  end
  

  def gainMagicElement(dice1, dice2)
    return "" unless(dice1 == dice2)
    
    # ゾロ目
    table = ['星','獣','力','歌','夢','闇']
    return " ＞ " + table[dice1 - 1] + "の魔素2が発生";
  end
    
#** 経歴表
  def magicalogia_background_table
    table = [
        '書警／ブックウォッチ',
        '司書／ライブラリアン',
        '書工／アルチザン',
        '訪問者／ゲスト',
        '異端者／アウトサイダー',
        '外典／アポクリファ',
            ]
    
    return get_table_by_1d6(table)
  end
  
  
#** 初期アンカー表
  def magicalogia_defaultanchor_table
    table = [
        '『恩人』あなたは、困っているところを、そのアンカーに助けてもらった。',
        '『居候』あなたかアンカーは、どちらかの家や経営するアパートに住んでいる。',
        '『酒友』あなたとアンカーは、酒飲み友達である。',
        '『常連』あなたかアンカーは、その仕事場によくやって来る。',
        '『同人』あなたは、そのアンカーと同じ趣味を楽しむ同好の士である。',
        '『隣人』あなたは、そのアンカーの近所に住んでいる。',
        '『同輩』あなたはそのアンカーと仕事場、もしくは学校が同じである。',
        '『文通』あなたは、手紙やメール越しにそのアンカーと意見を交換している。',
        '『旧友』あなたは、そのアンカーと以前に、親交があった。',
        '『庇護』あなたは、そのアンカーを秘かに見守っている。',
        '『情人』あなたは、そのアンカーと肉体関係を結んでいる。',
            ]
  
    return get_table_by_2d6(table)
  end
  
  
#** 運命属性表
  def magicalogia_fortune_attribution_table
    table = [
        '『血縁』自分や、自分が愛した者の親類や家族。',
        '『支配』あなたの部下になることが運命づけられた相手。',
        '『宿敵』何らかの方法で戦いあい、競い合う不倶戴天の敵。',
        '『恋愛』心を奪われ、相手に強い感情を抱いている存在。',
        '『興味』とても稀少だったり、不可解だったりして研究や観察をしたくなる対象。',
        '『尊敬』その才能や思想、姿勢に対し畏敬や尊敬を抱く人物。',
            ]
    
    return get_table_by_1d6(table)
  end
  
  
#** 願い表
  def magicalogia_wish_table
    table = [
        '自分以外の特定の誰かを助けてあげて欲しい。',
        '自分の大切な人や憧れの人に会わせて欲しい。',
        '自分をとりまく不幸を消し去って欲しい。',
        '自分のなくした何かを取り戻して欲しい。',
        '特定の誰かを罰して欲しい。',
        '自分の欲望（金銭欲、名誉欲、肉欲、知識欲など）を満たして欲しい。',
            ]
    
    return get_table_by_1d6(table)
  end
  
#** 指定特技ランダム決定表
  def magicalogia_random_skill_table
    output = '1';
    type = 'ランダム';
    
    skillTableFull = [
      ['星', ['黄金', '大地', '森', '道', '海', '静寂', '雨', '嵐', '太陽', '天空', '異界']],
      ['獣', ['肉', '蟲', '花', '血', '鱗', '混沌', '牙', '叫び', '怒り', '翼', 'エロス']],
      ['力', ['重力', '風', '流れ', '水', '波', '自由', '衝撃', '雷', '炎', '光', '円環']],
      ['歌', ['物語', '旋律', '涙', '別れ', '微笑み', '想い', '勝利', '恋', '情熱', '癒し', '時']],
      ['夢', ['追憶', '謎', '嘘', '不安', '眠り', '偶然', '幻', '狂気', '祈り', '希望', '未来']],
      ['闇', ['深淵', '腐敗', '裏切り', '迷い', '怠惰', '歪み', '不幸', 'バカ', '悪意', '絶望', '死']],
    ]
    
    skillTable, total_n = get_table_by_1d6(skillTableFull)
    tableName, skillTable = skillTable
    skill, total_n2 = get_table_by_2d6(skillTable)
    return "「#{tableName}」≪#{skill}≫", "#{total_n},#{total_n2}"
  end

  #特技だけ抜きたい時用 あまりきれいでない
  def magicalogia_random_skill_table_text_only
    text, num = magicalogia_random_skill_table
    return text
  end

  #魔素の種類獲得表
  def get_magic_element_type
    table = ['星','獣','力','歌','夢','闇']
    return get_table_by_1d6(table)
  end

#時の流れ表
  def magicalogia_time_passage_table
    output = "";
    num, dummy = roll(1,6)
    
    if num == 1
      output = "標的となり追われる生活が続いた。ここ数年は苦しい戦いの日々だった。#{magicalogia_random_skill_table_text_only}の判定を行う。成功するとセッション終了時に追加の功績点1点。失敗すると「運命変転」発生。"
    elsif num == 2
      output = "冒険の日々の途中、大きな幸せが訪れる。#{magicalogia_random_skill_table_text_only}の判定を行う。成功すると、自分のアンカーの災厄か、自分の疵一つを無効化する。"
    elsif num == 3
      text1, num1 = get_magic_element_type
      text2, num2 = get_magic_element_type
      text3, num3 = get_magic_element_type
      output = "瞑想から目を覚ます。もうそんな時間か。おかげで十分な魔素を得ることができた。「#{text1}」「#{text2}」「#{text3}」の魔素を獲得する。"
    elsif num == 4
      output = "傷を癒すには十分な時間だ。自分の【魔力】を最大値まで回復する。もしくは「魔力のリセット」を行うことができる。好きな方を選ぶこと。"
    elsif num == 5
      output = "平穏な日々の中にも、ちょっとした事件が起きる。自分のアンカーを一人選んで「事件表」を振ることができる。"
    elsif num == 6
      output = "日々研鑚を重ね、魔法の修行に精進した。もしも望むなら、蔵書欄にある魔法を、自分の修得できる範囲の中で、現在とは別の魔法に変更して構わない。もしも、魔素がチャージされていた魔法を見習得にした場合、その魔素は失われる。"
    end

    return output, num
  end

  #典型的災厄
  def magicalogia_typical_fortune_change_table
    table = [
      '挫折。自分にとって大切だった夢をあきらめる。',
      '別離。自分にとって大切な人―親友や恋人、親や兄弟などを失う。',
      '大病。不治の病を負う。',
      '借金。悪人に利用され、多額の借金を負う。',
      '不和。人間関係に失敗し深い心の傷を負う。',
      '事故。交通事故にあい、取り返しのつかないケガを負う。',
    ]
    return get_table_by_1d6(table)
  end
  #物理的災厄
  def magicalogia_physical_fortune_change_table
    table = [
      '火事。自分の家が焼け落ち、帰るところが無くなる。',
      '盗難。自分の大切なものが盗まれ、失われる。',
      '災害。自然災害に襲われ、生活環境が激変する',
      '失明。眼が見えなくなる。',
      '誘拐。何者かにさらわれ、監禁される。',
      '傷害。通り魔やあなたを憎む者に傷を負わされる。',
    ]
    return get_table_by_1d6(table)
  end
  #精神的災厄
  def magicalogia_mental_fortune_change_table
    table = [
      '倦怠。疲労感に襲われ、何もやる気がなくなる。',
      '家出。今、自分がいる場所に安らぎを感じなくなり、失踪する。',
      '憎悪。周囲の誰かやPCに対して激しい憎悪を抱くようになる。',
      '不眠。眠れなくなり、疲労する。',
      '虚言。本当のことを話せなくなってしまう。',
      '記憶喪失。友達やPCのことを忘れてしまう。',
    ]
    return get_table_by_1d6(table)
  end
  #狂気的災厄
  def magicalogia_insanity_fortune_change_table
    table = [
      '二重人格。もう一つの人格が現れ、勝手な行動を始める。',
      '恐怖。高所や異性、蜘蛛など、特定の何かに対する恐怖症になる。',
      '妄想。突拍子もない奇妙な妄想が頭を離れなくなる。',
      '偏愛。特定の物や状況などに熱狂的な愛情を示すようになる。',
      '暴走。時折、自分の感情が制御できなくなり、凶暴化する。',
      '発情。体温が上昇、脈拍が増大し、性的に興奮状態になる。',
    ]
    return get_table_by_1d6(table)
  end
  #社会的災厄
  def magicalogia_social_fortune_change_table
    table = [
      '逮捕。無実の罪で捕らわれ、留置される。',
      '裏切り。信頼していた人物に騙されたり、恋人に浮気されたりする。',
      '暴露。自分の隠しておきたい秘密を暴露される。',
      '籠絡。どう見てもよくない相手に心を奪われる。',
      '加害。人を傷つけたり、殺めたりしてしまう。',
      '多忙。とてつもない量の仕事に追われ、心身共に疲労する。',
    ]
    return get_table_by_1d6(table)
  end
  #超常的災厄
  def magicalogia_paranormal_fortune_change_table
    table = [
      '霊感。見えるはずのないものが見えるようになる。',
      '不運。身の回りで、不幸な偶然が頻発するようになる。',
      '感染。吸血鬼やゾンビなど、怪物になりかかってしまう。',
      '阻害。自分の存在が、魔法的存在以外から見えなくなってしまう。',
      '変身。姿が動物や別の人間に変わってしまう。',
      '標的。殺人鬼や魔法災厄など、悪意を引き寄せてしまう。',
    ]
    return get_table_by_1d6(table)
  end
  #不思議系災厄
  def magicalogia_wonderful_fortune_change_table
    table = [
      '邪気眼。ついつい痛い言動を繰り返すようになってしまう。',
      'ドジ。ありえないほどよく転び、物を壊す体質になってしまう。',
      '方向音痴。信じられないくらい道に迷うようになってしまう。',
      '変語尾。なぜか、自分が話す言葉の語尾が変になってしまう。',
      'ひらがな。話す言葉が全てひらがなで聞こえるようになる。',
      'ヤンデレ。PCのことを病的に愛するようになり、自分以外にPCへの好意を持つ者に対して攻撃的になる。',
    ]
    return get_table_by_1d6(table)
  end
  #コミカル系災厄
  def magicalogia_comical_fortune_change_table
    table = [
      '性別逆転。自分の肉体の性別が逆転してしまう。',
      '猫耳。頭から猫耳が生える。',
      '太る。びっくりするほど太る。',
      '足がくさい。哀しくなるほど足がくさくなる。',
      'ハラペコ。一回の食事で、ご飯を二十杯くらいおかわりしないと空腹でなにもできなくなる。',
      '脱衣。その場ですべての服が脱げる。',
    ]
    return get_table_by_1d6(table)
  end

  #ブランク秘密表用テーブル
  #宿敵表
  def magicalogia_inveterate_enemy_table
    output = "";
    num, dummy = roll(1, 6)
    if num == 1
      output = '嫉妬。その人物は、実は調査者の実力をねたむ〈大法典〉の魔法使いだった。データは〈火刑人〉を使用する。ただし、魔法の使用には魔素を必要とし、魔法使いをコレクションすることはできない。GMは調査者やそのアンカーに魔法戦を挑み、邪魔をするように操作すること。'
    elsif num == 2
      output = '蒐集。その人物は、実は調査者をコレクションしようとする〈書籍卿〉だった。データは〈混血主義者〉を使用する。GMは〈断章〉に立ち会ったり、魔法戦を挑んだりして、調査者の邪魔をするように操作すること。'
    elsif num == 3
      output = '妨害。その人物は、実は現在調査者が追っている〈断章〉を奪おうとする〈書籍卿〉だった。データは〈囁きの誘惑者〉を使用する。GMは〈断章〉に立ち会ったり、魔法戦を挑んだりして、調査者の邪魔をするように操作すること。'
    elsif num == 4
      output = "断章。その人物には、今回の件と関係ない〈断章〉が憑依していた。データは〈猛獣〉を使用する。ただし特技と召喚する騎士は#{magicalogia_random_skill_table_text_only}に変更する。GMは〈断章〉に立ち会ったり、魔法戦を挑んだりして、調査者の邪魔するように操作すること。"
    elsif num == 5
      output = '黒服。その人物は、実は魔法やオバケなどのあらゆる超常現象を否定する秘密結社「サークルエンド」の工作員だった。データは〈サークルエンド〉を使用する。GMは【隠蔽工作】を使用したり、魔法戦を挑んだりして、調査者の邪魔をするように操作すること。'
    elsif num == 6
      output = '忍者。その人物は、実はあなたを殺せという使命を受けた忍者である。データは〈忍者〉を使用する。GMは〈断章〉に立ち会ったり、魔法戦を挑んだりして、調査者の邪魔をするようにそうさすること。'
    end
    return output, num
  end

  #謀略表
  def magicalogia_conspiracy_table
    table = [
      '爆弾。その人物には、調査者の肉体を爆発させる魔法爆弾が仕掛けられていた。この【秘密】が公開されると、調査者は1d6点のダメージを受ける。',
      '呪詛。その人物には、調査者に感染する呪いの魔法が仕掛けられていた。この【秘密】が公開されると、調査者はランダムに選んだ変調を一つ受ける。',
      '幽閉。その人物には、調査者を異次元の牢獄に閉じ込める魔法が仕掛けられていた。この【秘密】が公開されると、調査者のプレイヤーがシーンプレイヤーになるか、クライマックスフェイズになるまで、シーンに登場できなくなる(マスターシーンでの登場の可否はGMが決定できる)。',
      '強化。その人物には、調査者の運命の力を吸収する魔法が仕掛けられていた。この【秘密】が公開されると、調査者のアンカーの数と同じ数まで、セッションに登場する〈断章〉の憑依深度が1上昇する。',
      '不幸。その人物には、調査者のアンカーに不幸な出来事を起こす魔法が仕掛けられていた。この【秘密】が公開されると、調査者のアンカーの中から〈愚者〉を一人選び、そのNPCに運命変転表を使用する。',
      '脱走。その人物には、〈断章〉の逃亡を手助けする魔法が仕掛けられていた。この【秘密】が公開されると、GMは〈断章〉一つとNPC一人を選ぶ。その〈断章〉は、そのNPCに憑依できる。このときGMは、すでに魔法使いによって回収された〈断章〉を選んでも良く、その場合【魔力】は1d6点回復する。',
    ]
    return get_table_by_1d6(table)
  end
  #因縁表
  def magicalogia_fate_table
    table = [
      '思慕。その人物は、実は調査者のことを知っており、深く愛していた。調査者はその人物に対する【運命】を2点上昇し、その属性を「恋愛」にする。その人物の【運命】の属性が「恋愛」の間、調査者は、この人物に対する【運命】が1点上昇するたび、【魔力】がその【運命】の値だけ回復する。',
      '縁者。その人物は、実は調査者と血縁関係があった。調査者はその人物に対する【運命】を2点上昇し、その属性を「血縁」にする。その人物の【運命】の属性が「血縁」の間、調査者の復活判定に、その【運命】の値だけプラスの修正がつく。',
      '怨恨。その人物は、実は調査者に深い恨みを持つ人物だった。調査者はその人物に対する【運命】を2点上昇し、その属性を「宿敵」にする。その人物の【運命】の属性が「宿敵」の間は、調査者がファンブルすると、その【運命】の値だけ【魔力】が減少する。',
      '狂信。その人物は、実は調査者を崇拝していた。調査者はその人物に対する【運命】を2点上昇し、その属性を「支配」にする。その人物の【運命】の属性が「支配」の間、調査者は、その人物に憑依した〈断章〉に魔法戦を挑んだ場合、自動的に勝利することができる。ただし、調査者は、行為判定のとき、その【運命】の値以下の目が出るとファンブルになる。',
      '分身。その人物は、実は調査者の魔法によって切り離された魂の一部だった。そのNPCは、調査者と融合し、調査者は功績点を1点獲得する。',
      '無関係。その人物は、今回の事件に特に関係はなかった。しかし、この出会いは本当に無意味だったのだろうか？ 調査者は、その人物を対象として事件表を振ること。',
    ]
    return get_table_by_1d6(table)
  end
  #奇人表
  def magicalogia_cueball_table
    table = [
      '寿命。その人物の命脈は尽きていた。この【秘密】が公開されると、その人物は死亡する。',
      '殺意。その人物は、世の中に対する憎悪に溢れ、無差別に誰かを傷つけようとしていた。GMはサイクルの終わりにランダムにこの【秘密】の持ち主以外のNPCを一人選ぶ。そのNPCが〈断章〉に憑依されていない〈愚者〉なら死亡し、そうでなければ、この【秘密】の持ち主本人が死亡する。このとき、いずれにせよその死亡を望まないキャラクターは「闇」の分野かの中からランダムに特技一つを選び、判定を行うことができる。判定に成功するとその死亡を無効化できる。',
      '強運。その人物は、一種の特異点で、とても強い幸運の持ち主だった。このNPCは、プライズとして扱う。このプライズの持ち主は、あらゆる行為判定を行うとき、プラス1の修正がつく。調査者は、このプライズを獲得する。',
      '疵痕。その人物は、過去に魔法によって大切なものを奪われており、魔法とその関係者を憎んでいる。その人物がいるシーンでは、召喚と呪文の判定にマイナス2の修正がつく。',
      '善人。その人物は、強く優しい精神の持ち主だった。その人物に対する【運命】を3点上昇する。',
      '依代。その人物は、霊媒体質で何かに憑依されやすい。この人物に〈断章〉が憑依した場合、【攻撃力】と【防御力】が2点ずつ上昇する。この【秘密】が公開されると、GMはサイクルの終わりに〈断章〉一つを選び、その憑依の対象をこのNPCに変更することができるようになる。ただし、すでに魔法使いによって回収された〈断章〉を選ぶことはできない。',
    ]
    return get_table_by_1d6(table)
  end
  #力場表
  def magicalogia_force_field_table
    table = [
      '加護。その人物の頭上には、常に星の恩寵が降り注いでいる。この【秘密】が公開されると、そのシーンに「星」の魔素が2点発生する。また、このセッションの間、この人物に対する【運命】が1点上昇したキャラクターは「星」の魔素を2点獲得する。',
      '変化(へんげ)。その人物は、実は歳を経た動物―狐や狸などが化けた存在である。この【秘密】が公開されると、そのシーンに「獣」の魔素が2点発生する。また、このセッションの間、この人物に対する【運命】が1点上昇したキャラクターは「獣」の魔素を2点獲得する。',
      '超能力。その人物には、ESPやPKなど、潜在的な超能力が眠っている。この【秘密】が公開されると、そのシーンに「力」の魔素が2点発生する。また、このセッションの間、この人物に対する【運命】が1点上昇したキャラクターは「力」の魔素を2点獲得する。',
      '詩人。その人物は、詩神に祝福された存在である。この【秘密】が公開されると、そのシーンに「歌」の魔素が2点発生する。また、このセッションの間、この人物に対する【運命】が1点上昇したキャラクターは「歌」の魔素を2点獲得する。',
      '夢想家。その人物には、大きな理想や実現したいと思っている夢がある。何か大きなことを成し遂げようとしている。。この【秘密】が公開されると、そのシーンに「夢」の魔素が2点発生する。また、このセッションの間、この人物に対する【運命】が1点上昇したキャラクターは「夢」の魔素を2点獲得する。',
      '暗黒。その人物は、呪われた運命を背負っており、世界の破滅を呼び込む可能性を持っている。この【秘密】が公開されると、そのシーンに「闇」の魔素が2点発生する。また、このセッションの間、この人物に対する【運命】が1点上昇したキャラクターは「闇」の魔素を2点獲得する。',
    ]
    return get_table_by_1d6(table)
  end
  #同盟表
  def magicalogia_alliance_table
    output = "";
    num, dummy = roll(1, 6)
    if num == 1
      output = "精霊。その人物は、実は姿を変え、人間界に顕現した精霊だった。象徴する特技は#{magicalogia_random_skill_table_text_only}である。調査者は、そのセッションの間だけ、その特技の【精霊召喚】を修得する。また、セッションに一度だけ、その【精霊召喚】の判定を自動的に成功にすることができる。"
    elsif num == 2
      output = "騎士。その人物は、実は姿を変え、人間界に顕現した騎士だった。象徴する特技は#{magicalogia_random_skill_table_text_only}である。調査者は、そのセッションの間だけ、その特技の【騎士召喚】を修得する。また、セッションに一度だけ、その【騎士召喚】の判定を自動的に成功にすることができる。"
    elsif num == 3
      output = "魔王。その人物は、実は姿を変え、人間界に顕現した魔王だった。象徴する特技は#{magicalogia_random_skill_table_text_only}である。調査者は、そのセッションの間だけ、その特技の【魔王召喚】を修得する。また、セッションに一度だけ、その【魔王召喚】の判定を自動的に成功にすることができる。"
    elsif num == 4
      output = '魔法屋。その人物は、魔法の道具を取引するタリスモンガーだった。以降、この人物のいるシーンでは、自分のチャージしている魔素1つを別の魔素1つに交換してもらうことができる。また、この人物のいるシーンでは、自分の装備魔法1つを修得可能な別の装備魔法1つに交換してもらうことができる。'
    elsif num == 5
      output = '師匠。その人物は、かつて調査者に魔法を教えた師匠だった。以降、この人物のいるシーンでは、自分の修得している特技1つを修得可能な別の特技1つに交換してもらうことができる。また、この人物のいるシーンでは、自分の呪文魔法1つを修得可能な別の呪文魔法1つに交換してもらうことができる。'
    elsif num == 6
      output = '無垢。その人物は、汚れ無き心の持ち主だった。このNPCは、プライズとして扱う。このプライズの持ち主は、セッション中に一度、【浄化】の呪文をコストなしで使用することができる。この判定は自動的に成功する。'
    end
    return output, num
  end

  #ブランク秘密表
  def magicalogia_blank_secret_table
    outtext = ""
    outnum = ''
    num, dummy = roll(1, 6)
    if num == 1
      outtext, outnum = magicalogia_inveterate_enemy_table
      outtext = "宿敵。#{outtext}"
    elsif num == 2
      outtext, outnum = magicalogia_conspiracy_table
      outtext = "謀略。#{outtext}"
    elsif num == 3
      outtext, outnum = magicalogia_fate_table
      outtext = "因縁。#{outtext}"
    elsif num == 4
      outtext, outnum = magicalogia_cueball_table
      outtext = "奇人。#{outtext}"
    elsif num == 5
      outtext, outnum = magicalogia_force_field_table
      outtext = "力場。#{outtext}"
    elsif num == 6
      outtext, outnum = magicalogia_alliance_table
      outtext = "同盟。#{outtext}"
    end
    outnum = "#{num},#{outnum}"
    return outtext, outnum
  end
  
  #プライズ表
  def magicalogia_prise_table
    table = [
      '敗者は内側から破裂し、四散する。功績点を1点獲得する。',
      '敗者は無数の蟲や小動物へと姿を変え、それを使い魔とする。勝者は好きな特技(魂の特技は除く)を一つ選ぶ。そのセッションの間、指定特技がその特技の【精霊召喚ん】【魔剣召喚】【悪夢召喚】のうち一つを修得する。',
      '敗者は爆発音と共にどこかへと消え、辺りには硫黄のような匂いだけが残る。勝者はそのセッション中に、一度だけ好きなタイミングで「変調」一種を回復することができる。',
      '敗者は奇妙な形をした数枚の金貨へと姿を変える。勝者は倒した相手のランクと等しい元型功績点を獲得する',
      '敗者は地面から突如現れた無数の腕に引き込まれながら、勝者に向かって賞賛の言葉と共に重要な何かを語る。公開されているハンドアウト一つを選び、その【秘密】を公開する。',
      '敗者は無数の光の粒へとなっていき、そこから魔素を得る。勝者は好きな魔素を2点獲得する(立会人に渡してもよい)。',
      '敗者はバラバラのページとなって地面に散らばり、そこから未知の力を読み取る。勝者は【一時的魔力】を2点獲得する。',
      '敗者は妙なる音楽へと変わり、その曲は勝者の心にしみいる。勝者は倒した相手のランクと等しい元型功績点を獲得する。',
      '敗者は一輪の花となる。勝者はそのセッション中に、一度だけ自分が振った行為判定のサイコロを振り直す権利を得る。',
      '敗者は言葉のかけらとなっていき、勝者はそこから未来の運命を読み取る。勝者は「事件表」を使用し、その結果を記録しておく。それ以降、そのセッション中のドラマシーンに、同じシーンに登場しているキャラクター一人を選び、一度だけその結果を適用できる。',
      '敗者は影となって、その場に焼き付き、異境への入り口となる。勝者は、好きな異境を一つ選ぶ。そのセッションの間、その異境へ移動できるようになる。',
    ]
    return get_table_by_2d6(table)
  end
  
  #極限環境シーン表
  def magicalogia_extreme_environment_scene_table
    table = [
      '上下左右も分からない、完全なる闇。このシーンに登場しているPCのうち一人は、≪光≫の判定を行う。成功すると、闇の魔素二個を獲得する。失敗すると、｢遮断｣の変調を受ける。誰かが判定を行うと、成否に関わらずこの効果はなくなる。',
      '眼前に広がる業火の海。何もかも喰らい尽すような敵意は圧倒的だ。≪炎≫の判定を行う。失敗すると【魔力】が2点減少する。',
      '激しい天候で地形が一変する。さきほどまでの光景が嘘のようだ。≪嵐≫で判定を行う。失敗すると、【魔力】が1点減少する。',
      'どこまでも続く、砂漠。舞い上がる砂塵に、目を開けていられない。≪大地≫の判定を行う。失敗すると、｢封印｣の変調を受ける。',
      '言葉さえも凍り付きそうな極寒。生き物の気配は感じられない。【魔力】が1点減少する。',
      lambda{return "苛酷な自然環境によってキミたちは窮地に立たされる。#{magicalogia_random_skill_table_text_only}の判定を行うこと。成功すると、なんとか使えそうなものを探し、好きな魔素が一個発生する。失敗すると、キミの負った傷は時間と空間を超えて、キミのアンカーに不幸をもたらす。「運命変転」が発生する。"},
      '一面の雪野原に、てんてんと足跡が残っている。どうやら、先客がいるらしい。',
      '切り立つ崖の上。眼下には大きな海が広がっている。上空からは海鳥の鳴き声が聞こえてくる。',
      '高重力の地。身体全体が鉛に変わってしまったかのように感じられる。≪重力≫の判定を行う。失敗すると【魔力】が1点減少する。',
      '深い水の底。青に染まった空間に、何かが漂っている。このシーンに登場しているPCのうち一人は≪海≫の判定を行うことができる。成功すると、星の魔素を三個獲得する。失敗すると、【魔力】が2点減少する。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
      '鼓膜を破りそうな、轟音が鳴り響く。言葉による意思の疎通は諦めた方がよさそうだ。≪旋律≫の判定を行う。失敗すると、チャージしているまその中から好きなものを二個失う。',
    ]
    return get_table_by_2d6(table)
  end
  
  #内面世界シーン表
  def magicalogia_innner_world_scene_table
    table = [
      '肌の色と熱い吐息で満たされた場所。無数の男女が、思いつく限りの肉の欲望を実践している。このシーンに登場しているPCのうち一人は、≪エロス≫の判定を行うことができる。成功すると【一時的魔力】を1点獲得する。失敗すると【魔力】が2点減少する。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
      '壁一面に、黒光りする虫がびっしりと張り付き、羽音を立てている部屋。この精神の持ち主は、虫が好きなのだろうか、嫌いなのだろうか。このシーンに登場しているPCのうち一人は、≪蟲≫の判定を行うことができる。成功すると、元型「蟲の騎士」をそのセッションの間、相棒にできる。相棒は、破壊か消滅するまで、自分が何らかのシーンに登場すると、そのシーンの種類に関わらず、同じタイミングで召喚される。失敗すると、虫が一斉に飛び立ち、そのシーンに登場しているPC全員の【魔力】が1点減少する。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
      '誰もいない教室。なぜか、ヒソヒソと囁く声がどこからともなく聞こえ、見られているような視線を感じる。このシーンに登場しているPCのうち一人は、≪不安≫の判定を行うことができる。成功すると、公開されているハンドアウトの中から、好きな【秘密】を公開することができる。失敗すると、「遮断」の変調を受ける。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
      '薄暗いが暖かく、ひどく安らぐ空間。ここはまるで、母親の胎内のようだ。このシーンに登場しているPCが、魔素を消費して、【魔力】の回復を行う場合、魔素一個につき、【魔力】を2点回復できる。',
      '遊園地。賑やかなパレードが目の前を通り過ぎて行くが、客は一人もいない。',
      lambda{return "夜の道。もやもやと黒いものが後ろから、追いかけてくる。はっきりした姿も分からないのに、ひどく恐ろしく感じる。このシーンに登場するPCは、#{magicalogia_random_skill_table_text_only}の判定を行う。成功すると、好きな魔素二個を獲得できる。失敗した場合、もやもやとした黒いものは君のアンカーの前に現れる。「運命変転」が発生する。"},
      '夕暮れの街。なんだか寂しい気分になる。',
      '床、壁、天井までが赤黒い色に染まった部屋。生臭い臭いが充満している。このシーンに登場しているPCのうち一人は≪血≫で判定を行うことができる。成功すると、【魔力】が1点減少する。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
      'どこへとも行くか知れぬ電車の中。あなたの他に乗客はいないようだが……。このシーンに登場しているPCのうち一人は≪異界≫で判定を行うことができる。成功すると、好きな異境一つに行くことができる魔法門を発見できる。失敗するとこのシーンに登場しているPC全員の【魔力】が2点減少する。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
      '大勢の人が行き交う雑踏の中。誰も、あなたに関心を払わない。このシーンでは「不干渉」の世界法則を無視して、好きなキャラクターを調査することができる。',
      'どことも知れぬ空間。あなたの最も愛しい人が、目の前に現れる。このシーンに登場しているPCのうち一人は、≪情熱≫の判定を行うことができる。成功すると、好きなアンカーに対する【運命】を1点上昇させることができる。失敗すると、「運命変転」が発生する。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
    ]
    return get_table_by_2d6(table)
  end
  
  #魔法都市シーン表
  def magicalogia_magic_city_scene_table
    table = [
      '急に爆発が起こる。誰かが実験で失敗したらしい。「綻び」の変調を受けた後、「力」の魔素を二個獲得する。',
      '標本の並ぶ地下室。実験によって生み出された魔法生物が、瓶詰めにされて並んでいる。',
      'ごった返す市場。色とりどり食料品や日用品を始め、幻獣の目玉やマンドラゴラの根といった、魔法の触媒となる品までが商われている。このシーンに登場しているPCは、一人一度だけ、功績点1点を消費することで、好きな魔素を二個獲得することができる。',
      '魔法使いたちの集うサロン。ここなら、有益な情報が得られそうだ。このシーンに登場しているPCのうち一人は、≪物語≫の判定を行うことができる。成功すると、公開されているハンドアウトの中から、好きな【秘密】を公開することができる。失敗すると「封印」の変調を受ける。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
      '大通り。幻獣の引く馬車や、絨毯や箒などの空飛ぶ乗り物が、せわしなく通り過ぎる。',
      lambda{return "広場。魔法使い同士が喧嘩を始め、魔法が飛び交い始める。このシーンに登場したPCは、#{magicalogia_random_skill_table_text_only}で判定を行う。成功すると、好きな魔素を二個獲得する。失敗すると、この場所の魔法の影響が時空を超えて、アンカーに現れる。「運命変転」が発生する。"},
      '賑わう酒場。客の中には妖精や魔物たちの姿も多い。このシーンに登場したPCは、【魔力】が1点回復する。',
      '入り組んだ路地裏。奇妙な異種族たちで構成された盗賊団に襲われる。≪雷≫で判定を行う。失敗すると【魔力】が2点減少するか、もし魔法にチャージした魔素を二個以上持っていればそれを消費するか、どちらかを選ぶ。',
      '都市の門。新たなる知識を求めてやってきた者、自分の世界へ帰る者、様々な世界の様々な人々が行き来する。',
      '歓楽街。角や尻尾、翼を持つ、肌もあらわな美女たちが、なまめかしい視線を送ってくる。このシーンに登場しているPCのうち一人は、≪エロス≫で判定を行うことができる。成功すると、元型「エロスの乙女」をそのセッションの間、相棒にできる。相棒は、破壊か消滅するまで、自分が何らかのシーンに登場すると、そのシーンの種類に関わらず、同じタイミングで召喚される。失敗すると【魔力】が1点減少する。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
      '闘技場。魔法使いが、強化した元型や幻獣を競い合わせている。シーンプレイヤーのPCは、一度だけ、基本ルールブックに載っている、ランク4以下の〈書籍卿〉か〈越境者〉に、魔法戦を挑むことができる。勝利すると、「プライズ表」を使用することができる。',
    ]
    return get_table_by_2d6(table)
  end
  
  #死後世界シーン表
  def magicalogia_world_after_dead_scene_table
    table = [
      '寂しげな村。影のような人々が時折行き来する。ここでは、死んだキャラクターに会うことができる。このシーンに登場しているPCのうち一人は、疵をひとつだけ、克服することができる。',
      'どこまでも広がる花畑。穏やかな雰囲気に満たされている。',
      '裁判所。強面の裁判官が、溢れる死者の群れに、次々と裁きを下している。≪嘘≫の判定を行う。失敗すると、【魔力】が2点減少する。',
      '白い光に包まれた食堂。豪勢な食事と美酒が、尽きることなく振る舞われる。このシーンに登場しているPCのうち一人は、≪肉≫の判定を行うことができる。成功すると、【一時的魔力】を1点獲得する。失敗すると、「病魔」の変調を受ける。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
      lambda{return "床が白い雲になっている場所。雲の隙間からは、現世のような風景が見える。#{magicalogia_random_skill_table_text_only}の判定を行う。成功すると、このセッション中一度だけ、判定のサイコロを振り直すことができる。失敗すると、時空を越えて、アンカーが死後世界を垣間見てしまう。「運命変転」が発生する。"},
      '広い川の岸辺。向こう岸は、現世なのだろうか。このシーンに登場しているPCのうち一人は≪円環≫の判定を行うことができる。成功すると、魔力をリセットできる。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
      '礼拝堂。死んでもなお、祈り続ける魂が、無言で跪いている。このシーンに登場しているPCのうち一人は、≪祈り≫の判定を行うことができる。成功すると、【一時的魔力】を2点獲得する。失敗すると、「不運」の変調を受ける。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
      'ごく普通の住宅街。日常の営みを繰り返す魂の集う場所だ。',
      '拷問場。鬼たちが、使者に無限の責め苦を味合わせている。このシーンに登場しているPCのうち一人は、≪絶望≫の判定を行うことができる。成功すると、【一時的魔力】を2点獲得する。失敗すると、「綻び」の変調を受ける。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
      '戦場。羽兜の乙女に率いられた戦士たちが、巨人と戦いを繰り広げている。このシーンに登場しているPCのうち一人は、≪天空≫で判定を行うことができる。成功すると、【一時的魔力】を3点獲得する。失敗すると、【魔力】が3点減少する。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
      'どことも知れぬ空間。あなたの最も愛しい人が、目の前に現れる。このシーンに登場しているPCのうち一人は、≪情熱≫の判定を行うことができる。成功すると、好きなアンカーに対する【運命】を1点上昇させることができる。失敗すると、「運命変転」が発生する。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
    ]
    return get_table_by_2d6(table)
  end
  
  #迷宮世界シーン表
  def magicalogia_labyrinth_world_scene_table
    table = [
      'がらんとした、石畳の部屋。床に描かれた魔法陣が、不気味な光を放っている。このシーンに登場しているPCのうち一人は、≪異界≫で判定を行うことができる。成功すると、その魔法陣を地球に帰還できる魔法門として使用できる。失敗すると、魔法門から現れた道の怪物に襲われ、このシーンに登場しているPC全員の【魔力】が1D6減少する。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
      '微かなランプの明かりに照らし出される牢獄。檻の中には、誰かの朽ちた骸が転がっている。このシーンに登場しているPCのうち一人は、≪死≫で判定を行うことができる。成功すると公開されているハンドアウトの中から、好きな【秘密】を公開することができる。失敗すると、死体が呪詛の言葉を吐き、このシーンに登場しているPC全員が「綻び」の変調を受ける。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
      '通路の先に、扉と看板がある。看板の文字は宿屋と読める。このシーンに登場しているPC全員は、一度だけ、功績点1点を消費することで、調律を一度行うことができる。',
      '人一人通るのが、やっとの狭い通路が続いている。この廊下はどこまで伸びているのだろう?',
      '幾つもの扉と幾つもの分かれ道を進む。おや？いつの間にか、きみは迷ってしまった。シーンプレイヤー以外のPCが、このシーンに登場しようとする場合、≪道≫で判定を行う。失敗したPCは、このシーンに登場できない。',
      lambda{return "怪物が現れ、キミたちを襲う。このシーンに登場しているPC全員は、#{magicalogia_random_skill_table_text_only}の判定を行うこと。成功すると、怪物を倒し、好きな魔素が一個発生する。失敗すると、キミの負った傷は時間と空間を越えて、キミのアンカーに不幸をもたらす。「運命変転」が発生する。"},
      '目の前には、似たような扉がずらりとならんでいる。どの扉を開いたものか?',
      '暗闇の中から、うなり声が聞こえてくる。どうやら、近くに怪物が潜んでいるようだ。うまくやりすごせないものか……。≪静寂≫で判定を行う。失敗すると、【魔力】が1点減少する。',
      '通路が途切れ、深い谷が口を開けている。谷底まで光は届かず、まるで地の底まで続いているかのようだ。「闇」の魔素を一個獲得できる。',
      '金貨や銀貨、宝石に王冠、山のような宝物の積み上げられた部屋。番人は見当たらないが……。このシーンに登場しているPCのうち一人は、≪黄金≫で判定を行うことができる。成功すると1D6点の元型功績点かランダムに決定した魔素三個を獲得できる。失敗すると、このシーンに登場しているPC全員の【魔力】が1点減少する。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
      '行き止まりの壁には、一見、意味不明な文字が並んでいる。ここから先に進むためには、この文字の謎を解かねばならないのだろうか。このシーンに登場しているPCのうち一人は、≪謎≫で判定を行うことができる。成功すると公開されているハンドアウトの中から、好きな【秘密】を公開することができる。失敗すると、部屋に仕掛けられた罠が発動し、このシーンは強制的に終了する。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
    ]
    return get_table_by_2d6(table)
  end
end
