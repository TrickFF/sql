USE vk;

-- Создаем таблицу лайков
DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  target_id INT UNSIGNED NOT NULL,
  target_type_id INT UNSIGNED NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Создаем таблицу типов лайков
DROP TABLE IF EXISTS target_types;
CREATE TABLE target_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Заполняем таблицу типов объектов для лайков
INSERT INTO target_types (name) VALUES 
  ('messages'),
  ('users'),
  ('media'),
  ('posts');

-- Создаем таблицу постов
CREATE TABLE posts (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  community_id INT UNSIGNED,
  head VARCHAR(255),
  body TEXT NOT NULL,
  media_id INT UNSIGNED,
  is_public BOOLEAN DEFAULT TRUE,
  is_archived BOOLEAN DEFAULT FALSE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

/* Задание 1. Создать и заполнить таблицы лайков и постов.
 * Таблицы лайков и постов созданы ранее.
 */

-- Заполняем таблицу лайков
INSERT INTO likes 
  SELECT 
    id, 
    FLOOR(1 + (RAND() * 100)), 
    FLOOR(1 + (RAND() * 100)),
    FLOOR(1 + (RAND() * 4)),
    CURRENT_TIMESTAMP 
  FROM messages;

-- Заполняем таблицу постов
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (1, 16, 1, 'Perferendis recusandae eius et voluptatem optio.', 'So she went on at last, and managed to put everything upon Bill! I wouldn\'t say anything about it, so she went nearer to make the arches. The chief difficulty Alice found at first was moderate. But.', 80, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (2, 85, 1, 'Neque reiciendis quia aut quo dolorem omnis.', 'Eaglet. \'I don\'t even know what \"it\" means.\' \'I know SOMETHING interesting is sure to kill it in a court of justice before, but she had finished, her sister sat still just as the whole thing, and.', 62, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (3, 84, 5, 'Aut voluptatem temporibus aut exercitationem eveniet nihil vel.', 'I\'LL soon make you grow taller, and the shrill voice of the day; and this Alice thought she might as well look and see that queer little toss of her sister, as well to introduce some other subject.', 52, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (4, 65, 3, 'Aut eveniet voluptatem recusandae et nihil fugiat.', 'Which shall sing?\' \'Oh, YOU sing,\' said the cook. The King turned pale, and shut his note-book hastily. \'Consider your verdict,\' the King say in a low, hurried tone. He looked anxiously at the other.', 21, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (5, 48, 2, 'Quasi perferendis non dolor at.', 'Alice considered a little, \'From the Queen. \'Can you play croquet?\' The soldiers were always getting up and repeat \"\'TIS THE VOICE OF THE SLUGGARD,\"\' said the Hatter, who turned pale and fidgeted..', 29, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (6, 15, 2, 'Ut aut assumenda sint nihil.', 'Off with his nose, and broke off a bit hurt, and she went on, \'you see, a dog growls when it\'s pleased. Now I growl when I\'m pleased, and wag my tail when I\'m angry. Therefore I\'m mad.\' \'I call it.', 67, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (7, 54, 1, 'Ipsa quo inventore ducimus consequatur quidem voluptates.', 'First, however, she went out, but it was certainly English. \'I don\'t believe there\'s an atom of meaning in it,\' said Alice. \'Off with their heads!\' and the shrill voice of the earth. Let me see--how.', 11, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (8, 89, 2, 'Culpa maiores libero quod expedita.', 'He says it kills all the time she found she had peeped into the Dormouse\'s place, and Alice joined the procession, wondering very much to-night, I should be like then?\' And she kept fanning herself.', 59, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (9, 73, 4, 'Voluptatem debitis ipsam impedit.', 'Mock Turtle persisted. \'How COULD he turn them out again. Suddenly she came up to the croquet-ground. The other side of WHAT?\' thought Alice; \'only, as it\'s asleep, I suppose you\'ll be asleep again.', 90, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (10, 14, 4, 'Dicta esse non velit quis.', 'Rabbit hastily interrupted. \'There\'s a great thistle, to keep herself from being run over; and the Queen shrieked out. \'Behead that Dormouse! Turn that Dormouse out of it, and found herself in a.', 42, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (11, 83, 3, 'Corporis ullam vitae cumque incidunt veniam aliquid.', 'Seven flung down his cheeks, he went on in the wood, \'is to grow up again! Let me see: that would happen: \'\"Miss Alice! Come here directly, and get ready for your interesting story,\' but she could.', 56, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (12, 96, 3, 'Enim non ea aut magnam.', 'She took down a large dish of tarts upon it: they looked so good, that it might be hungry, in which the March Hare will be When they take us up and walking away. \'You insult me by talking such.', 59, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (13, 22, 2, 'Deserunt vitae animi ullam incidunt deleniti sapiente doloribus.', 'Mock Turtle. Alice was very hot, she kept on good terms with him, he\'d do almost anything you liked with the Duchess, who seemed too much of a bottle. They all sat down a good thing!\' she said to.', 86, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (14, 48, 2, 'Sed impedit et quod.', 'Mary Ann, what ARE you talking to?\' said the Dormouse, after thinking a minute or two the Caterpillar took the cauldron of soup off the fire, stirring a large fan in the trial one way up as the rest.', 33, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (15, 95, 4, 'Cupiditate magni et sed corporis quis eligendi qui deleniti.', 'Edwin and Morcar, the earls of Mercia and Northumbria--\"\' \'Ugh!\' said the Lory, as soon as she spoke, but no result seemed to be lost, as she passed; it was not a regular rule: you invented it just.', 41, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (16, 15, 4, 'Labore consectetur eos ducimus deleniti inventore fuga.', 'The only things in the house, quite forgetting in the world you fly, Like a tea-tray in the world go round!\"\' \'Somebody said,\' Alice whispered, \'that it\'s done by everybody minding their own.', 82, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (17, 63, 1, 'Itaque corrupti quibusdam illo ad non facilis velit.', 'Alice. \'Come on, then,\' said Alice, who was beginning to write out a box of comfits, (luckily the salt water had not a regular rule: you invented it just at first, the two creatures, who had spoken.', 70, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (18, 36, 5, 'Iure est eum rerum aliquam qui velit et.', 'Alice: \'allow me to introduce it.\' \'I don\'t think they play at all what had become of you? I gave her one, they gave him two, You gave us three or more; They all sat down and cried. \'Come, there\'s.', 17, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (19, 13, 3, 'Illo recusandae autem suscipit aliquam delectus.', 'Cat, \'or you wouldn\'t mind,\' said Alice: \'besides, that\'s not a moment that it felt quite relieved to see what was the Duchess\'s voice died away, even in the distance, sitting sad and lonely on a.', 18, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (20, 77, 4, 'Et dicta dolores totam sunt.', 'Alice doubtfully: \'it means--to--make--anything--prettier.\' \'Well, then,\' the Gryphon remarked: \'because they lessen from day to such stuff? Be off, or I\'ll kick you down stairs!\' \'That is not said.', 35, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (21, 4, 2, 'Cumque ex rerum sunt amet consequatur omnis.', 'See how eagerly the lobsters to the cur, \"Such a trial, dear Sir, With no jury or judge, would be so proud as all that.\' \'Well, it\'s got no sorrow, you know. Come on!\' So they got their tails in.', 92, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (22, 89, 4, 'Nemo ullam dignissimos deserunt voluptates.', 'Lobster Quadrille, that she wanted to send the hedgehog a blow with its arms and frowning at the end of the edge of the tea--\' \'The twinkling of the well, and noticed that they were playing the.', 5, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (23, 98, 3, 'Quia voluptatum sequi ipsum distinctio.', 'King, \'that only makes the matter on, What would become of you? I gave her one, they gave him two, You gave us three or more; They all sat down a jar from one of the cupboards as she could, \'If you.', 12, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (24, 20, 1, 'Nesciunt quo doloribus excepturi odit.', 'Rabbit\'s little white kid gloves and a large plate came skimming out, straight at the bottom of a book,\' thought Alice \'without pictures or conversations?\' So she began: \'O Mouse, do you mean by.', 51, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (25, 53, 5, 'Ea quia consequuntur quia fugiat.', 'The only things in the world she was surprised to find that she had tired herself out with his head!\' or \'Off with her head!\' Alice glanced rather anxiously at the proposal. \'Then the Dormouse.', 62, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (26, 14, 2, 'Voluptatum hic ut modi inventore.', 'Dormouse. \'Write that down,\' the King triumphantly, pointing to the executioner: \'fetch her here.\' And the executioner ran wildly up and said, without even looking round. \'I\'ll fetch the executioner.', 52, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (27, 76, 3, 'Ducimus explicabo natus eaque libero.', 'Alice, (she had grown to her usual height. It was so ordered about by mice and rabbits. I almost think I can creep under the door; so either way I\'ll get into that lovely garden. First, however, she.', 44, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (28, 39, 4, 'Qui et est voluptatem repudiandae.', 'Alice timidly. \'Would you tell me, Pat, what\'s that in about half no time! Take your choice!\' The Duchess took no notice of her own children. \'How should I know?\' said Alice, who had been to her,.', 71, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (29, 76, 4, 'Magnam pariatur quasi molestias sequi voluptate perferendis a a.', 'Duchess; \'and the moral of THAT is--\"Take care of themselves.\"\' \'How fond she is such a pleasant temper, and thought to herself, \'Now, what am I to get hold of this remark, and thought it had been,.', 19, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (30, 96, 5, 'Laborum beatae et et autem.', 'Alice, \'and those twelve creatures,\' (she was so ordered about by mice and rabbits. I almost think I may as well say,\' added the Dormouse. \'Write that down,\' the King was the White Rabbit blew three.', 57, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (31, 72, 5, 'Harum deleniti qui totam non et.', 'March Hare moved into the darkness as hard as it was all dark overhead; before her was another long passage, and the pattern on their slates, when the race was over. Alice was beginning to think.', 1, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (32, 19, 5, 'Quia nesciunt sed vitae fuga numquam et quo.', 'PLEASE mind what you\'re doing!\' cried Alice, with a teacup in one hand and a sad tale!\' said the Caterpillar. Alice folded her hands, wondering if anything would EVER happen in a low voice. \'Not at.', 18, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (33, 87, 4, 'Consectetur assumenda aliquam fugit adipisci rerum.', 'Alice, and she tried to say \"HOW DOTH THE LITTLE BUSY BEE,\" but it makes me grow smaller, I can guess that,\' she added in an angry voice--the Rabbit\'s--\'Pat! Pat! Where are you?\' And then a voice.', 24, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (34, 62, 3, 'Architecto ducimus distinctio nulla quas pariatur.', 'PROVES his guilt,\' said the Hatter. \'It isn\'t a bird,\' Alice remarked. \'Right, as usual,\' said the King; and as he could go. Alice took up the chimney, has he?\' said Alice indignantly. \'Ah! then.', 61, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (35, 64, 5, 'Aut iusto explicabo dolores maxime optio.', 'ONE with such a capital one for catching mice--oh, I beg your pardon,\' said Alice sharply, for she had expected: before she got up, and there was mouth enough for it flashed across her mind that she.', 77, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (36, 1, 1, 'Molestias fugit nostrum ducimus eaque illum natus aperiam.', 'Mock Turtle, \'but if you\'ve seen them at dinn--\' she checked herself hastily. \'I thought it must be off, then!\' said the King, and the other paw, \'lives a Hatter: and in another minute there was not.', 95, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (37, 51, 5, 'Omnis enim omnis mollitia.', 'I don\'t know what to do that,\' said the Mock Turtle. \'Very much indeed,\' said Alice. \'And where HAVE my shoulders got to? And oh, I wish you could draw treacle out of a globe of goldfish she had.', 52, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (38, 52, 1, 'Ut enim ut est praesentium.', 'Dormouse, who seemed to have wondered at this, she noticed that they must be growing small again.\' She got up very carefully, nibbling first at one and then said \'The fourth.\' \'Two days wrong!\'.', 80, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (39, 30, 3, 'Aperiam qui error ratione cum autem quibusdam veritatis.', 'White Rabbit put on his spectacles. \'Where shall I begin, please your Majesty?\' he asked. \'Begin at the time they had to pinch it to the little door, so she bore it as to prevent its undoing.', 72, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (40, 22, 5, 'Tempora et at consequatur reprehenderit ex aspernatur molestiae.', 'She generally gave herself very good height indeed!\' said the King, \'and don\'t be nervous, or I\'ll kick you down stairs!\' \'That is not said right,\' said the King say in a trembling voice, \'--and I.', 17, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (41, 45, 2, 'Perspiciatis nobis laudantium debitis corrupti et dolorem.', 'NEAR THE FENDER, (WITH ALICE\'S LOVE). Oh dear, what nonsense I\'m talking!\' Just then her head in the distance, screaming with passion. She had just begun to repeat it, but her voice close to her.', 91, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (42, 91, 5, 'Omnis velit facere expedita.', 'Mock Turtle interrupted, \'if you don\'t explain it is right?\' \'In my youth,\' said the King; \'and don\'t be particular--Here, Bill! catch hold of this pool? I am now? That\'ll be a lesson to you to.', 6, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (43, 94, 5, 'Expedita saepe autem debitis saepe est consectetur cumque laboriosam.', 'King; \'and don\'t look at a king,\' said Alice. \'I\'ve tried the little door, so she bore it as a drawing of a treacle-well--eh, stupid?\' \'But they were nice grand words to say.) Presently she began.', 77, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (44, 66, 1, 'Eius odio adipisci cum dolor iure.', 'Dormouse. \'Write that down,\' the King triumphantly, pointing to Alice with one foot. \'Get up!\' said the Pigeon the opportunity of adding, \'You\'re looking for it, you know.\' \'I don\'t even know what.', 94, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (45, 46, 5, 'Sit voluptatem natus et quis et suscipit voluptas.', 'Hatter went on eagerly: \'There is such a new pair of white kid gloves while she ran, as well go back, and see how he did with the Lory, as soon as she spoke. \'I must be growing small again.\' She got.', 92, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (46, 48, 2, 'Quia beatae eos expedita.', 'Said cunning old Fury: \"I\'ll try the effect: the next verse,\' the Gryphon replied very politely, \'for I can\'t understand it myself to begin again, it was too much pepper in my own tears! That WILL.', 43, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (47, 84, 2, 'Inventore dolores voluptatum earum incidunt libero quia qui.', 'No, I\'ve made up my mind about it; and the Queen\'s hedgehog just now, only it ran away when it saw mine coming!\' \'How do you call him Tortoise--\' \'Why did they draw?\' said Alice, \'because I\'m not.', 82, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (48, 18, 2, 'Quibusdam et maiores iste provident sint eum distinctio.', 'Alice as she went on, \'What HAVE you been doing here?\' \'May it please your Majesty!\' the soldiers had to double themselves up and down looking for them, and was going to begin with,\' said the Mock.', 48, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (49, 95, 5, 'Voluptate provident aut fuga fuga voluptatem architecto.', 'March Hare. \'He denies it,\' said the cook. \'Treacle,\' said the Mock Turtle, and to stand on their faces, and the executioner ran wildly up and saying, \'Thank you, it\'s a very difficult question..', 44, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (50, 1, 4, 'Non sint et sunt quo itaque.', 'Alice replied in a tone of great relief. \'Now at OURS they had any dispute with the end of the goldfish kept running in her pocket, and pulled out a new idea to Alice, flinging the baby violently up.', 31, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (51, 66, 1, 'Voluptatem voluptatum nobis illum illo.', 'What would become of it; and as Alice could hardly hear the name \'Alice!\' CHAPTER XII. Alice\'s Evidence \'Here!\' cried Alice, with a sigh: \'it\'s always tea-time, and we\'ve no time she\'d have.', 39, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (52, 33, 3, 'Et culpa ipsa voluptates qui.', 'Alice for protection. \'You shan\'t be beheaded!\' said Alice, very loudly and decidedly, and there they are!\' said the Hatter. \'It isn\'t a letter, after all: it\'s a very little use, as it left no mark.', 18, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (53, 91, 4, 'Est quia omnis sint rerum rerum aut.', 'Five. \'I heard the Queen jumped up on tiptoe, and peeped over the jury-box with the tea,\' the March Hare said to herself. At this moment the door and found that, as nearly as she came upon a heap of.', 25, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (54, 35, 1, 'Quis et ullam nihil enim.', 'And she\'s such a subject! Our family always HATED cats: nasty, low, vulgar things! Don\'t let him know she liked them best, For this must ever be A secret, kept from all the while, and fighting for.', 22, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (55, 23, 5, 'Sint et aut voluptas qui rerum.', 'I NEVER get any older than I am very tired of being all alone here!\' As she said to one of them can explain it,\' said Alice to herself. \'Shy, they seem to encourage the witness at all: he kept.', 1, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (56, 67, 1, 'Sed et necessitatibus quia earum.', 'Alice could hardly hear the words:-- \'I speak severely to my right size: the next moment a shower of little pebbles came rattling in at the bottom of a well?\' The Dormouse again took a great hurry.', 55, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (57, 88, 1, 'Odio veritatis est beatae voluptatem.', 'Alice. \'Come on, then!\' roared the Queen, tossing her head through the neighbouring pool--she could hear him sighing as if it had VERY long claws and a Dodo, a Lory and an Eaglet, and several other.', 52, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (58, 2, 4, 'Itaque beatae qui voluptate maxime sint.', 'Alice began to feel which way she put one arm out of his shrill little voice, the name \'Alice!\' CHAPTER XII. Alice\'s Evidence \'Here!\' cried Alice, jumping up and down looking for eggs, I know who I.', 49, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (59, 34, 3, 'Neque nobis minus doloremque autem nesciunt veritatis laboriosam.', 'They all sat down again in a great deal to come down the middle, being held up by wild beasts and other unpleasant things, all because they WOULD go with the dream of Wonderland of long ago: and how.', 45, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (60, 83, 2, 'Ab est necessitatibus ad animi ipsum dignissimos tenetur.', 'The question is, what?\' The great question is, what?\' The great question is, what did the archbishop find?\' The Mouse looked at Alice. \'I\'M not a regular rule: you invented it just at present--at.', 52, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (61, 55, 3, 'Libero veritatis voluptates reprehenderit consequuntur dicta.', 'Footman, and began smoking again. This time there could be beheaded, and that you had been looking over their heads. She felt very lonely and low-spirited. In a little bit, and said nothing. \'This.', 58, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (62, 42, 5, 'Molestiae ut quis ab tempora ut sint aut.', 'Off with his head!\' or \'Off with her head! Off--\' \'Nonsense!\' said Alice, in a melancholy tone. \'Nobody seems to grin, How neatly spread his claws, And welcome little fishes in With gently smiling.', 57, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (63, 84, 3, 'Voluptas commodi et qui hic ipsam.', 'Alice, that she began thinking over all she could see it trying in a day or two: wouldn\'t it be of any one; so, when the race was over. However, when they arrived, with a T!\' said the others. \'Are.', 9, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (64, 43, 5, 'Laudantium tempore saepe deleniti distinctio.', 'Alice said; \'there\'s a large piece out of sight before the trial\'s begun.\' \'They\'re putting down their names,\' the Gryphon went on growing, and very neatly and simply arranged; the only difficulty.', 56, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (65, 6, 1, 'Maiores veniam porro nobis pariatur vel ut.', 'They all returned from him to be two people! Why, there\'s hardly enough of it now in sight, and no more of the hall; but, alas! either the locks were too large, or the key was too small, but at the.', 84, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (66, 29, 1, 'Incidunt quas culpa explicabo iure quia laudantium aliquam libero.', 'King, \'that only makes the world am I? Ah, THAT\'S the great question certainly was, what? Alice looked all round her at the Hatter, \'you wouldn\'t talk about her any more questions about it, you.', 27, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (67, 90, 5, 'Natus sunt nesciunt officiis odio est quae.', 'Cat. \'I said pig,\' replied Alice; \'and I wish you were never even spoke to Time!\' \'Perhaps not,\' Alice cautiously replied, not feeling at all know whether it was over at last: \'and I wish you.', 67, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (68, 90, 4, 'Soluta laboriosam voluptatem ad dolores laudantium maiores.', 'She generally gave herself very good height indeed!\' said the Duchess, \'and that\'s the queerest thing about it.\' \'She\'s in prison,\' the Queen said severely \'Who is this?\' She said this last remark.', 44, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (69, 89, 2, 'Vel voluptatem quos error nihil non quis aut.', 'Queen, the royal children; there were three gardeners who were giving it something out of the court, without even looking round. \'I\'ll fetch the executioner myself,\' said the Gryphon, half to.', 34, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (70, 1, 5, 'Consequatur praesentium reiciendis voluptatum enim vitae.', 'HE taught us Drawling, Stretching, and Fainting in Coils.\' \'What was THAT like?\' said Alice. \'Come on, then!\' roared the Queen, tossing her head to feel a little quicker. \'What a number of.', 1, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (71, 34, 3, 'Aut vel quisquam placeat vel.', 'Laughing and Grief, they used to know. Let me see: four times six is thirteen, and four times five is twelve, and four times six is thirteen, and four times seven is--oh dear! I wish I hadn\'t drunk.', 80, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (72, 85, 2, 'Quia dolorem accusantium voluptates ad sed aut tempore.', 'Queen was in livery: otherwise, judging by his garden, and I never knew so much contradicted in her French lesson-book. The Mouse looked at each other for some way, and the March Hare: she thought.', 69, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (73, 58, 5, 'Ex architecto nulla facilis voluptas voluptatibus accusamus nihil.', 'I do,\' said Alice in a moment to be no use speaking to it,\' she thought, \'it\'s sure to happen,\' she said to Alice, they all looked puzzled.) \'He must have been ill.\' \'So they were,\' said the.', 14, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (74, 48, 5, 'Placeat odio quis et sit accusamus.', 'ARE a simpleton.\' Alice did not at all know whether it was an old crab, HE was.\' \'I never could abide figures!\' And with that she did not venture to ask help of any one; so, when the Rabbit was.', 74, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (75, 26, 5, 'Eum unde unde doloremque unde sint.', 'Caterpillar decidedly, and he hurried off. Alice thought the poor little thing grunted in reply (it had left off quarrelling with the glass table and the game began. Alice thought over all the same,.', 86, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (76, 50, 3, 'Aut voluptatem corrupti consequuntur nulla.', 'Soon her eye fell on a little of it?\' said the Gryphon. \'--you advance twice--\' \'Each with a great deal too flustered to tell them something more. \'You promised to tell him. \'A nice muddle their.', 44, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (77, 63, 2, 'Libero labore dignissimos inventore enim necessitatibus est magnam non.', 'And she began thinking over all the while, and fighting for the Dormouse,\' thought Alice; \'I must be getting home; the night-air doesn\'t suit my throat!\' and a large arm-chair at one corner of it:.', 17, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (78, 39, 4, 'Odit repellendus iusto rerum qui vel eos.', 'King, with an air of great surprise. \'Of course not,\' Alice cautiously replied: \'but I must sugar my hair.\" As a duck with its mouth and yawned once or twice she had not as yet had any sense, they\'d.', 22, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (79, 35, 5, 'Voluptates optio autem dolorem delectus qui.', 'Pig!\' She said the Pigeon; \'but I know who I am! But I\'d better take him his fan and gloves. \'How queer it seems,\' Alice said to herself, as well as she swam nearer to watch them, and was in the.', 8, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (80, 91, 2, 'Odio et assumenda ullam ut dicta reiciendis.', 'Alice angrily. \'It wasn\'t very civil of you to get into that lovely garden. First, however, she again heard a voice of the house of the country is, you ARE a simpleton.\' Alice did not look at the.', 42, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (81, 38, 2, 'Qui dolor magnam voluptatem dolorum doloribus rem non veritatis.', 'See how eagerly the lobsters and the fan, and skurried away into the earth. Let me see: that would be QUITE as much as she went on. \'We had the dish as its share of the baby, it was only too glad to.', 14, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (82, 67, 5, 'Sint sunt aut aut hic.', 'King, rubbing his hands; \'so now let the Dormouse go on crying in this way! Stop this moment, and fetch me a good opportunity for croqueting one of the Mock Turtle. \'Hold your tongue!\' added the.', 59, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (83, 38, 4, 'Debitis porro facere voluptas eius possimus modi quisquam.', 'Five! Don\'t go splashing paint over me like a stalk out of the Gryphon, before Alice could hear the rattle of the jurymen. \'It isn\'t a letter, after all: it\'s a set of verses.\' \'Are they in the air..', 77, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (84, 43, 1, 'Deserunt et quaerat et nostrum a.', 'SOME change in my life!\' She had not gone far before they saw the White Rabbit, \'but it doesn\'t mind.\' The table was a little way out of breath, and said \'What else have you got in as well,\' the.', 53, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (85, 33, 4, 'Aspernatur voluptas omnis exercitationem consequatur porro.', 'Alice. \'You did,\' said the Pigeon. \'I\'m NOT a serpent!\' said Alice as it could go, and making faces at him as he spoke, and the moment she appeared on the look-out for serpents night and day! Why, I.', 58, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (86, 60, 4, 'Modi illo tempore est consequatur dolore dicta.', 'M, such as mouse-traps, and the small ones choked and had to ask his neighbour to tell me your history, you know,\' said Alice more boldly: \'you know you\'re growing too.\' \'Yes, but some crumbs must.', 67, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (87, 13, 2, 'Cum impedit officia distinctio esse.', 'Pennyworth only of beautiful Soup? Pennyworth only of beautiful Soup? Pennyworth only of beautiful Soup? Beau--ootiful Soo--oop! Beau--ootiful Soo--oop! Soo--oop of the song, perhaps?\' \'I\'ve heard.', 51, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (88, 4, 3, 'Possimus consequatur fuga eaque qui ducimus vel corrupti.', 'Alice asked in a game of play with a sudden leap out of the words came very queer indeed:-- \'\'Tis the voice of the Lobster Quadrille?\' the Gryphon hastily. \'Go on with the words \'DRINK ME,\' but.', 59, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (89, 20, 4, 'Fuga velit itaque nisi voluptas.', 'She was a body to cut it off from: that he had a little anxiously. \'Yes,\' said Alice desperately: \'he\'s perfectly idiotic!\' And she tried to fancy to cats if you like!\' the Duchess to play with, and.', 37, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (90, 63, 3, 'Praesentium nemo dolorem occaecati architecto vel odit.', 'Footman continued in the house, \"Let us both go to law: I will just explain to you never even spoke to Time!\' \'Perhaps not,\' Alice replied in an offended tone. And she tried to say than his first.', 59, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (91, 18, 4, 'Quidem quam eum velit et alias tenetur.', 'Alice, whose thoughts were still running on the twelfth?\' Alice went timidly up to her great delight it fitted! Alice opened the door opened inwards, and Alice\'s first thought was that you have to.', 61, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (92, 68, 3, 'Quia vel beatae eos eum officiis eum alias.', 'I wonder if I might venture to say it out loud. \'Thinking again?\' the Duchess was VERY ugly; and secondly, because they\'re making such a wretched height to rest her chin upon Alice\'s shoulder, and.', 91, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (93, 2, 4, 'Est ex quia animi odit.', 'Cat. \'I\'d nearly forgotten to ask.\' \'It turned into a large crowd collected round it: there was enough of me left to make out that it was just in time to hear her try and repeat something now. Tell.', 92, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (94, 95, 5, 'Perferendis natus labore quia exercitationem similique.', 'PRECIOUS nose\'; as an unusually large saucepan flew close by it, and talking over its head. \'Very uncomfortable for the accident of the cupboards as she could, and soon found herself in a minute..', 72, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (95, 22, 3, 'Quis ut rerum amet dolores.', 'EVER happen in a great hurry; \'and their names were Elsie, Lacie, and Tillie; and they went on again:-- \'You may go,\' said the Mock Turtle drew a long sleep you\'ve had!\' \'Oh, I\'ve had such a curious.', 91, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (96, 51, 5, 'Cumque accusamus possimus omnis ut sit.', 'I only knew how to begin.\' He looked anxiously over his shoulder as he fumbled over the list, feeling very glad to get through was more than nine feet high, and she felt a very decided tone: \'tell.', 72, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (97, 90, 4, 'Nihil sed quas fugiat quasi id nihil inventore nihil.', 'So she stood watching them, and just as well look and see that queer little toss of her knowledge. \'Just think of what sort it was) scratching and scrambling about in the distance. \'And yet what a.', 83, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (98, 44, 4, 'Et facilis qui consequatur aut et animi.', 'IS that to be listening, so she turned to the door. \'Call the next moment she appeared; but she thought it must be shutting up like telescopes: this time it vanished quite slowly, beginning with the.', 76, 0, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (99, 100, 5, 'Enim ut accusantium et quos mollitia maxime.', 'Alice; \'only, as it\'s asleep, I suppose you\'ll be telling me next that you couldn\'t cut off a little nervous about this; \'for it might be some sense in your knocking,\' the Footman remarked, \'till.', 42, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `created_at`, `updated_at`) VALUES (100, 62, 2, 'Rerum asperiores quasi esse.', 'YOU?\' said the Duchess, as she could, and waited till the puppy\'s bark sounded quite faint in the court!\' and the poor little juror (it was Bill, I fancy--Who\'s to go through next walking about at.', 30, 1, 0, '2021-01-03 11:06:17', '2021-01-03 11:06:17');

-- Задание 2. Создать все необходимые внешние ключи и диаграмму отношений.
/* Переделываем столбец gender_id таблицы profiles
 * по причине того, что для него был изначально задан неверный тип данных */
ALTER TABLE profiles
 ADD gender_id2 int unsigned NOT NULL COMMENT 'Ссылка на пол' AFTER gender_id;

UPDATE profiles SET gender_id2=gender_id;
ALTER TABLE profiles DROP COLUMN gender_id;
ALTER TABLE profiles RENAME COLUMN gender_id2 TO gender_id;


-- Удаляем внешние ключи таблицы profiles
ALTER TABLE profiles 
  DROP CONSTRAINT profiles_user_id_fk,
  DROP CONSTRAINT profiles_photo_id_fk,
  DROP CONSTRAINT profiles_gender_id_fk,
  DROP CONSTRAINT profiles_user_status_id_fk;

-- Добавляем внешние ключи для таблицы profiles
ALTER TABLE profiles
  ADD CONSTRAINT profiles_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT profiles_photo_id_fk
    FOREIGN KEY (photo_id) REFERENCES media(id)
      ON DELETE SET NULL,     
  ADD CONSTRAINT profiles_gender_id_fk
    FOREIGN KEY (gender_id) REFERENCES gender(id)
      ON DELETE NO ACTION,
  ADD CONSTRAINT profiles_user_status_id_fk
    FOREIGN KEY (user_status_id) REFERENCES user_statuses(id)
      ON DELETE SET NULL;
     
-- Удаляем внешние ключи таблицы media
ALTER TABLE media 
  DROP CONSTRAINT media_user_id_fk,
  DROP CONSTRAINT media_type_id_fk;
 
-- Добавляем внешние ключи для таблицы media
ALTER TABLE media
  ADD CONSTRAINT media_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT media_type_id_fk
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
      ON DELETE NO ACTION;
     

-- Удаляем внешние ключи таблицы communities_users
ALTER TABLE communities_users
  DROP CONSTRAINT comm_users_user_id_fk,
  DROP CONSTRAINT comm_users_comm_id_fk;
 
-- Добавляем внешние ключи для таблицы communities_users
ALTER TABLE communities_users
  ADD CONSTRAINT comm_users_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT comm_users_comm_id_fk
    FOREIGN KEY (community_id) REFERENCES communities(id)
      ON DELETE CASCADE;
     
/* Внешние ключи для двух полей одной таблицы на одно поле второй таблицы
 *  ставятся только при отключенной проверке */
SET FOREIGN_KEY_CHECKS=0     

-- Удаляем внешние ключи таблицы friendship
ALTER TABLE friendship
  DROP CONSTRAINT friendship_user_id_fk,
  DROP CONSTRAINT friendship_friend_id_fk,
  DROP CONSTRAINT friendship_status_id_fk;
 
-- Добавляем внешние ключи для таблицы friendship
ALTER TABLE friendship
  ADD CONSTRAINT friendship_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON UPDATE CASCADE ON DELETE CASCADE,
  ADD CONSTRAINT friendship_friend_id_fk
    FOREIGN KEY (friend_id) REFERENCES users(id)
      ON UPDATE CASCADE ON DELETE CASCADE,
  ADD CONSTRAINT friendship_status_id_fk
    FOREIGN KEY (status_id) REFERENCES friendship_statuses(id)
      ON UPDATE CASCADE ON DELETE CASCADE;
     
    
-- Удаляем внешние ключи таблицы messages
ALTER TABLE messages
  DROP CONSTRAINT messages_from_user_id_fk,
  DROP CONSTRAINT messages_to_user_id_fk;

-- Добавляем внешние ключи для таблицы messages
ALTER TABLE messages
  ADD CONSTRAINT messages_from_user_id_fk 
    FOREIGN KEY (from_user_id) REFERENCES users(id)
      ON DELETE NO ACTION,
  ADD CONSTRAINT messages_to_user_id_fk 
    FOREIGN KEY (to_user_id) REFERENCES users(id)
      ON DELETE NO ACTION;

 
-- Удаляем внешние ключи таблицы contacts
ALTER TABLE contacts
  DROP CONSTRAINT contacts_user_id_fk;

-- Добавляем внешние ключи для таблицы contacts
ALTER TABLE contacts
  ADD CONSTRAINT contacts_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON UPDATE CASCADE ON DELETE CASCADE;  
     
     
-- Удаляем внешние ключи таблицы posts
ALTER TABLE posts
  DROP CONSTRAINT posts_user_id_fk,
  DROP CONSTRAINT posts_community_id_fk,
  DROP CONSTRAINT posts_media_id_fk;

-- Добавляем внешние ключи для таблицы posts
ALTER TABLE posts
  ADD CONSTRAINT posts_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE NO ACTION,
  ADD CONSTRAINT posts_community_id_fk 
    FOREIGN KEY (community_id) REFERENCES communities(id)
      ON UPDATE CASCADE ON DELETE CASCADE,
  ADD CONSTRAINT posts_media_id_fk 
    FOREIGN KEY (media_id) REFERENCES media(id)
      ON UPDATE CASCADE ON DELETE CASCADE;
     
     
-- Удаляем внешние ключи таблицы likes
ALTER TABLE likes
  DROP CONSTRAINT likes_user_id_fk,
  DROP CONSTRAINT likes_target_type_id_fk;

-- Добавляем внешние ключи для таблицы likes
ALTER TABLE likes
  ADD CONSTRAINT likes_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE NO ACTION,
  ADD CONSTRAINT likes_target_type_id_fk 
    FOREIGN KEY (target_type_id) REFERENCES target_types(id)
      ON DELETE NO ACTION;
     
     
/* Задание 3. 
 * Определить кто больше поставил лайков (всего) - мужчины или женщины? */

SELECT COUNT(*) FROM likes WHERE user_id IN (SELECT user_id FROM profiles WHERE gender_id = 1)
UNION
SELECT COUNT(*) FROM likes WHERE user_id IN (SELECT user_id FROM profiles WHERE gender_id = 2);


/* Задание 4.
 * Подсчитать количество лайков которые получили 10 самых молодых пользователей. */

-- выборка 10 самых молодых пользователей
SELECT user_id, birthday FROM profiles ORDER BY birthday DESC LIMIT 10;

/* Не работает ограничение LIMIT в подзапросе
 * SQL Error [1235] [42000]: This version of MySQL doesn't yet support 'LIMIT & IN/ALL/ANY/SOME subquery'*/
SELECT COUNT(*) FROM likes WHERE user_id IN (SELECT user_id FROM profiles ORDER BY birthday DESC LIMIT 10);

-- Пришлось искать решение через костыть
SELECT COUNT(*) FROM likes
WHERE user_id NOT IN 
(SELECT user_id from 
 (SELECT user_id FROM profiles ORDER BY birthday DESC LIMIT 10) x
);

/* Задание 5. 
 * Найти 10 пользователей, которые проявляют наименьшую активность в
 *  использовании социальной сети (критерии активности необходимо определить самостоятельно). */

-- Выберем 10 наимеее активных исходя из общего количества постов и поставленных лайков
SELECT 
  id,
  (SELECT first_name FROM profiles WHERE user_id = id) AS FirstName,
  (SELECT last_name FROM profiles WHERE user_id = id) AS LastName,
  (SELECT COUNT(*) FROM posts GROUP BY user_id HAVING user_id = id) AS posts,
  (SELECT COUNT(*) FROM likes GROUP BY user_id HAVING user_id = id) AS likes,  
  (SELECT SUM(posts + likes)) AS Total
FROM users ORDER BY posts ASC, likes ASC LIMIT 10;

-- Выберем 10 наиболее активных исходя из общего количества постов и поставленных лайков
SELECT 
  id,
  (SELECT first_name FROM profiles WHERE user_id = id) AS FirstName,
  (SELECT last_name FROM profiles WHERE user_id = id) AS LastName,
  (SELECT COUNT(*) FROM posts GROUP BY user_id HAVING user_id = id) AS posts,
  (SELECT COUNT(*) FROM likes GROUP BY user_id HAVING user_id = id) AS likes,  
  (SELECT SUM(posts + likes)) AS Total
FROM users ORDER BY Total DESC LIMIT 10;
