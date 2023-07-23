var timerId;
var minutes = 0;
var seconds = 0;

document.addEventListener('DOMContentLoaded', function() {
    var playButtons = document.querySelectorAll('.play-button');
    var stopButtons = document.querySelectorAll('.stop-button');

    playButtons.forEach(function(button) {
      button.addEventListener('click', function(event) {
        event.preventDefault(); // Prevent default form submission

        var currentButton = this;
        var currentButtonText = currentButton.innerText;

        var stopButton = this.parentNode.nextElementSibling.querySelector('.stop-button');

        var url = this.dataset.url;

        // Perform AJAX request
        fetch(url, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
          },
          body: JSON.stringify({ currentButtonText: currentButtonText }) // Include the current button text as a parameter
        })
          .then(function(response) {
            if (response.ok) {
              if (currentButton.innerText === 'Play') {
                resetTimer();
                startTimer();
                currentButton.innerText = 'Pause';
                stopButton.disabled = false;

                // if i start another task where is another one running, should be paused
                playButtons.forEach(p=> {
                  if (p!=currentButton && p.innerText ==='Pause'){
                    p.innerText = 'Play'
                  }
                });

              } else {
                pauseTimer();
                currentButton.innerText = 'Play';
              }
            } else {
              console.error('Error performing action');
            }
          })
          .catch(function(error) {
            console.error('Error performing action:', error);
          });
      });
    });

    stopButtons.forEach(function(button) {
      button.addEventListener('click', function(event) {
        event.preventDefault(); // Prevent default form submission

        var playButton = this.parentNode.previousElementSibling.querySelector('.play-button');

        var url = this.dataset.url;

        // Perform AJAX request
        fetch(url, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
          },
          //body: JSON.stringify({ currentButtonText: currentButtonText }) // Include the current button text as a parameter
        })
          .then(function(response) {
            if (response.ok) {
              resetTimer();
              playButton.innerText = 'Play';
              playButton.disabled = true;

            } else {
              console.error('Error performing action');
            }
          })
          .catch(function(error) {
            console.error('Error performing action:', error);
          });
      });
    });

  });

function startTimer(){

  timerId = setInterval(function() {
    updateTimer();
  }, 1000);
}

function resetTimer(){
  minutes = 0;
  seconds = 0;
  var counterElement = document.getElementById('counter');

  counterElement.innerText = "00:00"
  clearInterval(timerId);
}

function pauseTimer(){
  clearInterval(timerId);
}

function updateTimer() {
  var counterElement = document.getElementById('counter');

  seconds++;
  if (seconds === 60) {
    minutes++;
    seconds = 0;
  }
  var formattedMinutes = minutes < 10 ? '0' + minutes : minutes;
  var formattedSeconds = seconds < 10 ? '0' + seconds : seconds;
  counterElement.innerText = formattedMinutes + ':' + formattedSeconds;
}
