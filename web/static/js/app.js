// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"

let feedContainer = document.getElementById("feed-stream");

if (feedContainer) {
  let channel = socket.channel("feed:lobby", {})
  channel.join()
    .receive("ok", resp => { renderFeeds(resp.feeds) })
    .receive("error", resp => { console.log("Unable to join", resp) })

    channel.on("new_feed", data => { feedContainer.insertBefore(renderFeed(data.feed), feedContainer.firstChild); })

  function renderFeeds (feeds) {
    feeds.map( feed => feedContainer.appendChild(renderFeed(feed)) );
  }

  function renderFeed (feed) {
    let template = document.createElement("div");
    let linkTag = renderFeedLink(feed);
    template.innerHTML = `
      <div class="panel panel-default">
        <div class="panel-heading">
          ${feed.title}
        </div>
        <div class="panel-body">
          <div class="row">
            <div class="col-sm-3">
              <div class="thumbnail">
                <img src="${feed.user.picture_url}" />
              </div>
            </div>
            <div class="col-sm-9">
              ${feed.content}
            </div>
          </div>
        </div>
        <div class="panel-footer">
          ${feed.inserted_at}
          ${linkTag}
        </div>
      </div>
    `;
    return template;
  }

  function renderFeedLink (feed) {
    if (feed.link === null || feed.link == "") {
      return "";
    }

    let template = document.createElement("span");
    template.className = "pull-right";
    template.innerHTML = `
      <a href="${feed.link}">
        Open
      </a>
    `;
    return template.outerHTML;
  }
}

let borrowBookCopyWidget = document.getElementById("borrow-book-copy-widget");

if (borrowBookCopyWidget) {
  let bookCopyId = borrowBookCopyWidget.getAttribute("data-book-copy-id");
  let currentUserId = borrowBookCopyWidget.getAttribute("data-current_user_id");
  let token = borrowBookCopyWidget.getAttribute("data-token");
  let borrowChannel = socket.channel(`borrow_book_copy:${bookCopyId}`, {token: token});
  borrowChannel.join()
    .receive("ok", resp => { renderWidget(resp.status); })
    .receive("error", resp => { console.log(resp); });

  borrowChannel.on("borrowing_updated", data => { renderWidget(data) });

  function renderWidget (status) {
    if (status.available === true) {
      borrowBookCopyWidget.innerHTML = renderAvailableToBorrow();
      document.querySelector(".to-borrow").addEventListener("click", e => {
        borrowChannel.push("borrow");
      });
    } else if (status.borrowed_by.user_id == currentUserId) {
      borrowBookCopyWidget.innerHTML = renderCanReturn();
      document.querySelector(".to-return").addEventListener("click", e => {
        borrowChannel.push("return");
      });
    } else {
      borrowBookCopyWidget.innerHTML = renderCantBorrow(status.borrowed_by);
    }
  }

  function renderAvailableToBorrow () {
    let template = document.createElement("div");
    let borrowButton = document.createElement("a");
    borrowButton.innerText = "I'm borrowing it!";
    borrowButton.className = "btn btn-primary btn-lg btn-block to-borrow";
    template.appendChild(borrowButton);

    return template.outerHTML;
  }

  function renderCanReturn () {
    let template = document.createElement("div");
    let returnButton = document.createElement("a");
    returnButton.innerText = "OK. I want to return it now.";
    returnButton.className = "btn btn-info btn-lg btn-block to-return";
    template.appendChild(returnButton);

    return template.outerHTML;
  }

  function renderCantBorrow (borrowed_by) {
    let template = document.createElement("div");
    let button = document.createElement("button");
    button.innerText = "I'm borrowing it!";
    button.setAttribute("disabled", "disabled");
    button.className = "btn btn-primary btn-lg btn-block to-borrow";
    template.appendChild(button);
    let infoSpan = document.createElement("span");
    infoSpan.innerText = `Copy borrowed by ${borrowed_by.first_name} ${borrowed_by.last_name}.`;
    infoSpan.className = "text-muted";
    template.appendChild(infoSpan);

    return template.outerHTML;
  }
}
