# FetchRewardsiOSExercise

This project is done completely in UIKit and Swift. I have tried to break down the discussion of this project into following topics:


<h2>Architecture: MVVM</h2>

  EventsDisplayer acts as a view model for EventsViewController. The view model and view controller interacts in the following way:

	i. The view model provides all the events to view controller which is displayed by 
	view controller in a tableview.

	ii. When the user enters text in searchBar, the view controller asks model to display
	events based on the entered search text.

	iii. The view controller asks the model if is loading the events. 
	
		model.isLoadingEvents { showLoadingSpinner() }
		else { showTableView() }

	iv. The view controller also asks view model to keep a dictionary of cached images.
	These images are events’ images which are fetched from the network. The caching is 
	done to prevent the repeated network calls for the same image.



<h2>User Interfaces</h2>


	The user interfaces are implemented using AutoLayout. The UI is mostly done programmatically using constraints. I have used extensions for some UI elements to achieve desired functionality or to keep uniformity throughout the app. 

	For example, 
		someLabel.titled() will make a UILabel bold and of a particular size. So, wherever 
		I need a title, I used this method.

	My detail view controller for events looks little different than provided blueprint. The title and images are positioned differently. And I have also given some shadow effect to the favorite button.



<h2>Communication pattern: Delegation and Protocol</h2>

	In this project, EventsViewController (View) depends on EventsDisplayer (View Model) for everything. To display events, the view controller just accesses view models “displayedEvents” property. 

	Initially, the displayedEvents is empty. The view model asks the network layer to fetch the events. After events are fetched, it populates the “displayedEvents” property. I needed a way to let view controller know that the data is fetched and the view controller can reload its table view. Thats where, Delegation and Protocol pattern came in handy. 

	The view model has a delegate which is a “EventsDisplayerDelegate”. EventsDisplayerDelegate is a protocol which requires just one method “didSetEvents”. When view controller was initialized, I set the view controller as the view model’s delegate which required the view controller to conform the protocol and implement the required method. That’s where I implemented the “reloadData()” method. 

	The implemented method fires up when the events are fetched and “displayedEvents” property of view model is set because of the following code:

	displayedEvents: [Event]() {
		didSet {
			delegate.didSetEvents()
		}
	}




<h2>Functional Programming</h2>

	When the favorite button in detail view controller is clicked, I had to reload the tableview to display the current state. The detail vc should communicate with events vc in some way. So, I decided to provide an action as a parameter for detail vc. That action fires up when favorite button is clicked on detail vc. And when detail vc is initialized on events vc, the event vc has to implement a closure. Here, I could call “reloadData()” method.

	let detailVC = DetailViewController(for: event) {
		// favorite button is clicked on detail 
		// do what you need to do here
	}
	



<h2>Persistence: UserDefaults</h2>

	When the user chooses an event as a favorite, the event’s id is saved in the UserDefaults. Now when the events are displayed in the table view, I just had to do one thing:

	Check if the id of an event in a particular row is present in the UserDefaults’s saved ids array. It true, the cell will show the “heart”.

	The reason I decided to use the UserDefaults was the data I had to save was just an array of few ints.


<h2>Networking Layer</h2>

	The networking is done with URLSession and JSON parsing is done with the use of Codable protocol.
