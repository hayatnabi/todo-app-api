class Api::V1::TodosController < ApplicationController
  def index
    todos = @current_user.todos
    render json: todos
  end

  def create
    todo = @current_user.todos.build(todo_params)
    if todo.save
      render json: todo, status: :created
    else
      render json: { errors: todo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    todo = @current_user.todos.find(params[:id])
    if todo.update(todo_params)
      render json: todo
    else
      render json: { errors: todo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    todo = @current_user.todos.find_by(id: params[:id])
  
    if todo
      todo.destroy
      render json: { message: 'Todo deleted successfully', todo: todo }, status: :ok
    else
      render json: { error: "Todo not found for this user with todo_id: #{params[:id]}" }, status: :not_found
    end
  end
  

  def destroy_all
    todos = Todo.where(user_id: @current_user.id)
    
    if todos.exists?
      deleted_count = todos.delete_all
      render json: { message: "#{deleted_count} todos deleted successfully" }, status: :ok
    else
      render json: { message: "No todos found for the current user" }, status: :not_found
    end
  end
  

  private

  def todo_params
    params.permit(:title, :done)
  end
end
