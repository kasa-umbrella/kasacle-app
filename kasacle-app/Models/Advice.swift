//
//  Advice.swift
//  kasacle-app
//
//  Created by 笠原涼太 on 2026/02/18.
//

import Foundation

/// トレーニングアドバイスのデータモデル
struct Advice {
    let icon: String
    let message: String
}

/// すべてのアドバイスリスト
let allAdvices: [Advice] = [
    // トレーニング関連（プッシュ系）
    Advice(icon: "flame.fill", message: "胸・肩・三頭筋のプッシュ系トレーニングで上半身を鍛えましょう。"),
    Advice(icon: "figure.strengthtraining.traditional", message: "ベンチプレス、ショルダープレス、ディップスで押す力を強化しましょう。"),
    Advice(icon: "figure.arms.open", message: "胸のストレッチを意識して、大胸筋を最大限に収縮させましょう。"),
    Advice(icon: "circle.hexagongrid.fill", message: "三角筋を鍛えて、逆三角形のシルエットを目指しましょう。"),

    // トレーニング関連（プル系）
    Advice(icon: "dumbbell.fill", message: "背中・二頭筋のプル系トレーニングで引く力を強化しましょう。"),
    Advice(icon: "figure.flexibility", message: "懸垂、ベントオーバーロー、デッドリフトで背中の厚みを作りましょう。"),
    Advice(icon: "arrow.down.to.line", message: "肩甲骨を寄せる動きを意識して、広背筋をしっかり刺激しましょう。"),
    Advice(icon: "figure.cooldown", message: "背中のトレーニング後は、肩周りをしっかりストレッチしましょう。"),

    // トレーニング関連（脚）
    Advice(icon: "bolt.fill", message: "脚・臀部のトレーニングで代謝をアップさせましょう。"),
    Advice(icon: "figure.stairs", message: "スクワット、ランジ、レッグプレスで下半身を強化しましょう。"),
    Advice(icon: "figure.step.training", message: "大腿四頭筋、ハムストリング、臀筋をバランスよく鍛えましょう。"),
    Advice(icon: "flame.circle.fill", message: "脚のトレーニングは最もカロリーを消費します。全力で追い込みましょう。"),

    // トレーニング関連（体幹・全身）
    Advice(icon: "figure.core.training", message: "体幹トレーニングで姿勢を整え、ケガを予防しましょう。"),
    Advice(icon: "figure.strengthtraining.traditional", message: "コンパウンド種目を中心に、複数の筋肉を同時に鍛えましょう。"),
    Advice(icon: "figure.mixed.cardio", message: "プランク、サイドプランクで体幹の安定性を高めましょう。"),
    Advice(icon: "square.3.layers.3d", message: "腹筋は毎日鍛えてもOK。様々な角度から刺激を与えましょう。"),

    // ストレッチ・柔軟性
    Advice(icon: "figure.cooldown", message: "ストレッチで柔軟性を高め、可動域を広げましょう。"),
    Advice(icon: "figure.roll", message: "トレーニング前のダイナミックストレッチで体を温めましょう。"),
    Advice(icon: "figure.yoga", message: "トレーニング後のスタティックストレッチで筋肉をほぐしましょう。"),
    Advice(icon: "person.crop.circle", message: "肩甲骨周りをほぐして、トレーニング効果を高めましょう。"),

    // 休養・回復
    Advice(icon: "moon.zzz.fill", message: "しっかり休養しましょう。睡眠と栄養補給が筋肉の回復を助けます。"),
    Advice(icon: "heart.fill", message: "アクティブレストの日。ヨガやストレッチで全身をケアしましょう。"),
    Advice(icon: "figure.walk", message: "軽いウォーキングやストレッチで回復を促しましょう。"),
    Advice(icon: "bed.double.fill", message: "質の高い睡眠は最高のサプリメント。今日は早めに休みましょう。"),
    Advice(icon: "lungs.fill", message: "深呼吸とリラックスで副交感神経を活性化し、回復を促進しましょう。"),
    Advice(icon: "drop.degreesign.fill", message: "トレーニング後のアイシングで炎症を抑え、回復を早めましょう。"),
    Advice(icon: "powersleep", message: "7〜9時間の睡眠で成長ホルモンの分泌を最大化しましょう。"),

    // 栄養・水分補給
    Advice(icon: "drop.fill", message: "水分補給を意識しながらトレーニングしましょう。"),
    Advice(icon: "fork.knife", message: "トレーニング後30分以内にタンパク質を摂取して筋肉の回復を促しましょう。"),
    Advice(icon: "carrot.fill", message: "バランスの良い食事で栄養をしっかり補給しましょう。"),
    Advice(icon: "cup.and.saucer.fill", message: "プロテインだけでなく、野菜からのビタミン・ミネラルも大切です。"),
    Advice(icon: "fish.fill", message: "オメガ3脂肪酸で炎症を抑え、関節の健康を保ちましょう。"),
    Advice(icon: "antenna.radiowaves.left.and.right", message: "こまめな食事で筋肉の分解を防ぎ、エネルギーを維持しましょう。"),
    Advice(icon: "wineglass.fill", message: "トレーニング前の糖質補給で、パフォーマンスを最大化しましょう。"),
    Advice(icon: "pills.fill", message: "マルチビタミンで微量栄養素を補い、体調を整えましょう。"),

    // モチベーション
    Advice(icon: "star.fill", message: "今日も一歩一歩、着実に積み上げていきましょう。"),
    Advice(icon: "trophy.fill", message: "小さな成功を積み重ねることが、大きな成果につながります。"),
    Advice(icon: "target", message: "目標を明確にして、今日のトレーニングに集中しましょう。"),
    Advice(icon: "chart.line.uptrend.xyaxis", message: "継続は力なり。毎日少しずつ前進していきましょう。"),
    Advice(icon: "checkmark.seal.fill", message: "昨日の自分を超えることが、最高の目標です。"),
    Advice(icon: "flag.fill", message: "長期的な目標を持ちながら、今日できることに集中しましょう。"),
    Advice(icon: "hands.sparkles.fill", message: "努力は裏切らない。今日のトレーニングが未来を作ります。"),
    Advice(icon: "crown.fill", message: "自分を信じて。あなたは思っている以上に強くなれます。"),

    // フォーム・テクニック
    Advice(icon: "eye.fill", message: "重量よりもフォームが大切。正しいフォームで安全にトレーニングしましょう。"),
    Advice(icon: "speedometer", message: "ゆっくりとした動作で筋肉に効かせることを意識しましょう。"),
    Advice(icon: "hands.clap.fill", message: "呼吸を意識して。力を入れる時に息を吐き、戻す時に吸いましょう。"),
    Advice(icon: "figure.mind.and.body", message: "マインド・マッスル・コネクション。鍛えている筋肉を意識しましょう。"),
    Advice(icon: "gauge.with.dots.needle.67percent", message: "フルレンジで動作して、筋肉を完全に伸縮させましょう。"),
    Advice(icon: "pause.fill", message: "収縮位置で1〜2秒キープすると、より効果的です。"),
    Advice(icon: "camera.metering.center.weighted", message: "体の中心軸を意識して、安定したフォームを保ちましょう。"),

    // バリエーション
    Advice(icon: "arrow.triangle.2.circlepath", message: "いつもと違う種目にチャレンジして、新しい刺激を与えましょう。"),
    Advice(icon: "figure.run", message: "有酸素運動と筋トレのバランスで、全身の健康を目指しましょう。"),
    Advice(icon: "timer", message: "セット間のインターバルを計測して、効率的にトレーニングしましょう。"),
    Advice(icon: "shuffle", message: "種目の順番を変えることで、新たな刺激を筋肉に与えられます。"),
    Advice(icon: "arrow.up.arrow.down", message: "スーパーセットで時間効率を上げ、筋肉への刺激を最大化しましょう。"),
    Advice(icon: "waveform.path.ecg", message: "テンポを変えることで、筋肉に異なる負荷をかけられます。"),

    // マインドセット
    Advice(icon: "brain.head.profile", message: "筋トレは体だけでなく、心も鍛えてくれます。"),
    Advice(icon: "sparkles", message: "自分の成長を楽しみながら、無理なく続けることが大切です。"),
    Advice(icon: "leaf.fill", message: "焦らず、自分のペースで着実に進んでいきましょう。"),
    Advice(icon: "light.beacon.max.fill", message: "ポジティブな気持ちで取り組むと、トレーニング効果も高まります。"),
    Advice(icon: "person.2.fill", message: "仲間と励まし合うことで、モチベーションを高く保てます。"),
    Advice(icon: "calendar.badge.clock", message: "習慣化が最強の武器。決まった時間にトレーニングしましょう。"),
    Advice(icon: "book.fill", message: "トレーニングログをつけて、自分の成長を可視化しましょう。"),

    // 科学的知識
    Advice(icon: "circle.grid.cross.fill", message: "筋肥大には8〜12回で限界が来る重量が最適です。"),
    Advice(icon: "atom", message: "筋肉痛がなくても、トレーニング効果はあります。気にせず続けましょう。"),
    Advice(icon: "waveform", message: "48〜72時間の休養で、筋肉は修復され強くなります。"),
    Advice(icon: "chart.bar.xaxis", message: "週2〜3回の筋トレで、確実に筋力アップできます。"),
    Advice(icon: "list.number", message: "各部位を週に2回鍛えるのが、筋肥大に最も効果的です。"),
]
