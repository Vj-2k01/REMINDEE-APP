import 'package:flutter/material.dart';
import 'package:remindee/remindee.dart';
import 'package:url_launcher/url_launcher.dart';

class WellnessTipsPage extends StatelessWidget {
  const WellnessTipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Wellness Tips'),
      // ),
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).colorScheme.primary,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Remindee()));
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Wellness Tips',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.article),
                  title: Text('Wellness Articles'),
                  onTap: () {
                    // Navigate to the wellness articles page
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => WellnessArticlesPage())));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.fitness_center),
                  title: Text('Exercise and Stretching Videos'),
                  onTap: () {
                    // Navigate to the exercise videos page
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => ExerciseVideosPage())));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.mood),
                  title: Text('Mindfulness and Meditation'),
                  onTap: () {
                    // Navigate to the mindfulness and meditation page
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) =>
                                MindfulnessMeditationPage())));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.restaurant_menu),
                  title: Text('Healthy Recipes'),
                  onTap: () {
                    // Navigate to the healthy recipes page
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => HealthyRecipesPage())));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.nights_stay),
                  title: Text('Sleep Hygiene Tips'),
                  onTap: () {
                    // Navigate to the sleep hygiene tips page
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => SleepHygienePage())));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WellnessArticlesPage extends StatelessWidget {
  final List<Map<String, String>> articles = [
    {
      'title': '10 Tips for a Healthy Lifestyle',
      'link': 'https://www.healthline.com/nutrition/10-healthy-lifestyle-tips'
    },
    {
      'title': 'The Importance of Daily Exercise',
      'link':
          'https://www.mayoclinic.org/healthy-lifestyle/fitness/in-depth/exercise/art-20048389'
    },
    {
      'title': 'Managing Stress: Techniques and Strategies',
      'link': 'https://www.apa.org/topics/stress-management'
    },
    // Add more articles here
  ];

  WellnessArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Wellness Articles'),
      // ),
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).colorScheme.primary,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WellnessTipsPage()));
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Wellness Articles',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return ListTile(
                  title: Text(article['title']!),
                  onTap: () {
                    // Open the article link in a web browser
                    launch(article['link']!);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ExerciseVideosPage extends StatelessWidget {
  final List<Map<String, String>> videos = [
    {
      'title': 'Eye Exercises for Eye Strain Relief',
      'url': 'https://youtu.be/fKv1k254_kk'
    },
    {'title': 'Full Body Workout', 'url': 'https://youtu.be/AzV3EA-1-yM'},
    {'title': 'Yoga for Beginners', 'url': 'https://youtu.be/s2NQhpFGIOg'},
    {'title': 'Cardio Dance Workout', 'url': 'https://youtu.be/ZWk19OVon2k'},
    // Add more videos here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Exercise Videos'),
      // ),
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).colorScheme.primary,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WellnessTipsPage()));
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Exercise Videos',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];
                return ListTile(
                  title: Text(video['title']!),
                  onTap: () {
                    // Open the video URL in a web browser or video player
                    launch(video['url']!);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MindfulnessMeditationPage extends StatelessWidget {
  final List<Map<String, String>> meditations = [
    {
      'title': 'Guided Meditation for Relaxation',
      'url': 'https://youtu.be/O-6f5wQXSu8'
    },
    {
      'title': 'Morning Mindfulness Meditation',
      'url': 'https://youtu.be/-0pBgI6yuwI'
    },
    {'title': 'Body Scan Meditation', 'url': 'https://youtu.be/-bOnLrlCTbw'},
    // Add more meditations here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Mindfulness and Meditation'),
      // ),
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).colorScheme.primary,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WellnessTipsPage()));
                  },
                ),
                Text(
                  'Mindfulness \nand Meditation',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: meditations.length,
              itemBuilder: (context, index) {
                final meditation = meditations[index];
                return ListTile(
                  title: Text(meditation['title']!),
                  onTap: () {
                    // Open the meditation URL in a web browser or meditation app
                    launch(meditation['url']!);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HealthyRecipesPage extends StatelessWidget {
  final List<Map<String, String>> recipes = [
    {
      'title': 'Quinoa Salad with Veggies',
      'url': 'https://youtu.be/rIYqwpgNhu0'
    },
    {'title': 'Baked Salmon with Lemon', 'url': 'https://youtu.be/2uYoqclu6so'},
    {'title': 'Vegetable Stir-Fry', 'url': 'https://youtu.be/spDs_wzn8To'},
    // Add more recipes here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Healthy Recipes'),
      // ),
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).colorScheme.primary,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WellnessTipsPage()));
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Healthy Recipes',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return ListTile(
                  title: Text(recipe['title']!),
                  onTap: () {
                    // Open the recipe link in a web browser
                    // Open the meditation URL in a web browser or meditation app
                    launch(recipe['url']!);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SleepHygienePage extends StatelessWidget {
  final List<Map<String, String>> tips = [
    {
      'title': 'Establish a Consistent Sleep Schedule',
      'description':
          'Go to bed and wake up at the same time every day, even on weekends.',
    },
    {
      'title': 'Create a Relaxing Bedtime Routine',
      'description':
          'Engage in relaxing activities like reading or taking a warm bath before bed.',
    },
    {
      'title': 'Ensure a Comfortable Sleep Environment',
      'description':
          'Keep your bedroom dark, quiet, and at a comfortable temperature.',
    },
    // Add more tips here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Sleep Hygiene Tips'),
      // ),
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).colorScheme.primary,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WellnessTipsPage()));
                  },
                ),
                Text(
                  'Sleep Hygiene Tips',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tips.length,
              itemBuilder: (context, index) {
                final tip = tips[index];
                return ListTile(
                  title: Text(tip['title']!),
                  subtitle: Text(tip['description']!),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
