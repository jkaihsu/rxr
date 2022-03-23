## Todo List backend / frontend example

## Rails Backend Example
#### Generate Controller and Model
```In root directory
$ rails g controller api/v1/Tdlists index create update destroy --no-helper --no-assets --no-template-engine --no-test-framework
$ rails g model Tdlist title:string done:boolean --no-helper --no-assets --no-template-engine --no-test-framework
```
#### Modify config/routes.rb
```
resources :tdlists, only: [:index, :show, :create, :update, :destroy]
```
#### Modify app/controllers/api/v1/tdlists_controller.rb
```
class Api::V1::TdlistsController < ApplicationController
  def index
    tdlists = Tdlist.order('CREATED_AT DESC')
    render json: tdlists, status: 200
  end

  def create
    tdlist = Tdlist.create(tdlist_params)
    render json: tdlist, status: 200
  end

  def update
    tdlist = Tdlist.find_by_id(params[:id])
    
    if tdlist
      tdlist.update(tdlist_params)
      render json: tdlist, status: 200
    else
      render json: { error: 'List not found' }
    end
  end

  def destroy
    tdlist = Tdlist.find_by_id(params[:id])
    if tdlist
      tdlist.destroy
      head :no_content, status: :ok
    else
      render json: { error: 'List not found' }
    end
  end
  
  private
  
  def tdlist_params
    params.require(:tdlist).permit(:title, :done)
  end
end
```
#### Add to db/seeds.rb
```
Tdlist.create(title: "Prepare for interivew", done: false)
Tdlist.create(title: "Call mom", done: false)
Tdlist.create(title: "Buy gift for friend", done: false)
Tdlist.create(title: "Workout", done: false)
Tdlist.create(title: "Buy Cat food", done: false)
```
#### Migration
```
$ rake db:drop; rake db:create; rake db:migrate; rake db:seed
```
#### Rails Server
```
$ rails s -p 3001
```
#### View JSON
```
http://localhost:3001/api/v1/tdlists/
```
___

## React Frontend Example
#### Create directory and file
```
$ cd app-frontend
$ mkdir src/components
$ touch src/components/TdlistsContainer.js
```
#### Add React Packages
```
# HTTP request
$ npm install axios --save

# Immutability Helper
$ npm install immutability-helper --save

# Proxy Middlware
$ npm install http-proxy-middleware --save
```

#### Replace in app-frontend/src/App.css
```
.mainContainer {
  width: 35%;
  height: 500px;
  position: relative;
  border-radius: 7px;
  margin: 0 auto;
}

.wrapItems {
  position: absolute;
  bottom: 55px;
  top: 170px;
  right: 0;
  left: 0;
  overflow: auto;
}

.topHeading {
  color: rgb(48, 2, 2);
  font-family: "Times New Roman", Times, serif, sans-serif;
  padding: 7px;
  text-align: center;
}

ul.listItems {
  padding: 0 30px;
}

input.itemCheckbox {
  margin-right: 8px;
  position: relative;
  -webkit-appearance: none;
  float: left;
  border: 1.5px solid #ccc;
  width: 18px;
  height: 18px;
  border-radius: 7px;
  cursor: pointer;
  text-align: center;
  outline: none;
  margin-left: 7px;
  font-weight: bold;
}

li.item {
  font-family: "Times New Roman", Times, serif;
  list-style-type: none;
  font-size: 1.5em;
  border-bottom: 2px solid rgba(80, 2, 90, 0.411);
  padding: 5px 0;
}

li.item:hover .removeItemButton {
  opacity: 2;
  visibility: visible;
}

input.itemCheckbox:checked:after {
  color: green;
  width: 15px;
  content: "\2713";
  font-size: 15px;
  display: block;
  height: 15px;
  left: 0.7px;
  position: absolute;
  bottom: 1.8px;
}

input.itemCheckbox:checked + label.itemDisplay {
  color: #f807a8;
  text-decoration: line-through;
}

input.itemCheckbox + label.itemDisplay {
  color: black;
}

input[placeholder] {
  font-size: 1.2em;
}

.taskContainer {
  padding: 15px;
}

.removeItemButton {
  float: right;
  visibility: hidden;
  color: red;
  background: rgba(0, 0, 0, 0);
  font-size: 25px;
  font-weight: bold;
  line-height: 0;
  border: 1px solid white;
  border-radius: 50%;
  padding: 10px 5px;
  opacity: 0;
  margin-right: 7px;
  cursor: pointer;
}

.taskContainer .newTask {
  padding: 10px;
  width: 100%;
  box-sizing: border-box;
  border-radius: 25px;
}
```
#### Add code in TdlistsContainer.js

```
import React, {Component} from "react";
import axios from "axios";
import update from "immutability-helper";

class TdlistsContainer extends Component {
	constructor(props) {
		super(props);
		this.state = {
			tdlists: [],
			inputValue: "",
		};
		this.setState({
			tdlists: [],
			inputValue: "",
		});
	}

	componentDidMount() {
		this.loadTdlists();
	}

	loadTdlists() {
		axios.get('/api/v1/tdlists').then((response) => {
			this.setState({
				tdlists: response.data
			});
		}).catch((error) => console.log(error));
	}

	handleChange = (e) => {
		this.setState({inputValue: e.target.value});
	};

	newTdlist = (e) => {
		if (e.key === "Enter" && !(e.target.value === "")) {
			axios.post("/api/v1/tdlists", {
				tdlist: {
					title: e.target.value,
					done: false
				}
			}).then(
				(response) => {
					const tdlists = update(this.state.tdlists, {
						$splice: [[0, 0, response.data]],
					});
					console.log({$splice: [[0, 0, response.data]]})

					this.setState({
						tdlists: tdlists,
						inputValue: "",
					});
				})
				.catch((error) => console.log(error));
		}
	};

	modifyTdlist = (e, id) => {
		axios.put(`/api/v1/tdlists/${id}`, {
			tdlist: {done: e.target.checked}
		}).then(
			(response) => {
				const tdlistIndex = this.state.tdlists.findIndex(
					(x) => x.id === response.data.id
				);
				const tdlists = update(this.state.tdlists, {
					[tdlistIndex]: {$set: response.data},
				});
				this.setState({
					tdlists: tdlists,
				});
			}).catch(
			(error) => console.log(error)
		);
	}

	removeTdlist = (id) => {
		axios.delete(`/api/v1/tdlists/${id}`).then(
			(response) => {
				const tdlistIndex = this.state.tdlists.findIndex((x) => x.id === id);
				const tdlists = update(this.state.tdlists, {
					$splice: [[tdlistIndex, 1]],
				});
				this.setState({
					tdlists: tdlists,
				});
			}).catch((error) => console.log(error));
	}

	render() {
		return (
			<div>
				<div className="taskContainer">
					<input
						className="newTask"
						type="text"
						placeholder="Input a New Task and Press Enter"
						maxLength="75"
						onKeyPress={this.newTdlist}
						value={this.state.inputValue}
						onChange={this.handleChange}
					/>
				</div>
				<div className="wrapItems">
					<ul className="listItems">
						{this.state.tdlists?.map((tdlist) => {
							return (
								<li className="item" tdlist={tdlist} key={tdlist.id}>
									<input
										className="itemCheckbox"
										type="checkbox"
										checked={tdlist.done}
										onChange={(e) => this.modifyTdlist(e, tdlist.id)}
									/>
									<label className="itemDisplay">{tdlist.title}</label>
									<span
										className="removeItemButton"
										onClick={(e) => this.removeTdlist(tdlist.id)}
									>x</span>
								</li>
							)
						})}
					</ul>
				</div>
			</div>
		);
	}
}

export default TdlistsContainer;
```
#### Replace code in ${app-frontend}/src/App.js
```
import React, { Component } from "react";
import "./App.css";
import TdlistsContainer from "./components/TdlistsContainer";

class App extends Component {
  render() {
    return (
      <div className="mainContainer">
        <div className="topHeading">
          <h1>A Simple To-Do List App</h1>
        </div>
        <TdlistsContainer />
      </div>
    );
  }
}

export default App;
```

## Run Server for both Rails backend and React frontend
```In root directory
$  heroku local -f Procfile.windows
```

## Reference Guide
[Rails Api](https://medium.com/swlh/how-to-build-an-api-with-ruby-on-rails-28e27d47455a) <br>
[React](https://www.section.io/engineering-education/how-to-integrate-a-react-application-with-rails-api/)
