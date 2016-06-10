#Peer to Peer Communication

defmodule Talker do
	def start() do
		spawn(fn-> loop(true) end)
	end

	def loop(silencio) do
		_silencio = silencio
		receive do
			{:talk, name} -> 
				if (silencio) do
					send(self, {:notify, "zaraza"})
				end
				pid = spawn(&Listener.loop/0)
				send(pid, {:greet, name})
				loop(_silencio)
			{:notify, _} -> 
				IO.puts("Talker - notifiquemos")
				pid = spawn(&Listener.loop/0)
				send(pid, {:notify, "Alguien"})
				loop(_silencio)
			{:silenciar} ->
				IO.puts("Talker - silenciemos")
				loop(!_silencio)	
		end
	end
end

defmodule Listener do
	
	def loop do
		receive do
			{:greet, name} -> IO.puts("Listener - Hello #{name}")
			{:notify, name} -> IO.puts("Listener - #{name}, esta escribiendo")
			{:celebrate, name, age} -> IO.puts("Listener - Here's to another #{age} years, #{name}")
		end
	loop
	end
end


#Chat Grupal

defmodule GroupChat do
  def start(map) do
    spawn fn -> loop(map) end
  end

  def loop(map) do
    receive do

      {:subscribe, name, memberPid} ->
      	  IO.puts("GroupChat - Subscribe user #{name}")
          loop(Map.put(map, name, memberPid))

#      {:broadcastMessage, message, senderPid} ->
#          send(self, {:broadcastMessage, message, senderPid, Map.to_list(map)})
	
#	  {:broadcastMessage, message, senderPid, list} ->
	  	  #message => {
	  	  #	case 
	  	  #}
	  	  #if (list )
	  	  #	loop(map)
	  	  # member = list.get()
	  	  #if (member == ) do
	  	  	# send(self, {:broadcastMessage, message, senderPid, Map.to_list(map)})
	  	  #else
	  	  	# send member, 
	  	  	# send(self, {:broadcastMessage, message, senderPid, Map.to_list(map)})	
    end
  end

end  

defmodule GroupMember do
	
	def start(name) do
	  spawn fn -> loop(name) end
	end

	def loop(name) do
		receive do
			{:subscribe, chatPid, memberPid} -> 
				IO.puts("#{name} -  Voy a intentar suscribirme")
				send chatPid, {:subscribe, name, memberPid}
				loop(name)
#			{:broadcastMessage, chatPid, message} -> 
#				IO.puts("#{name} -  Voy a decir algo")
#				send chatPid, {:broadcastMessage, message, memberPid}
#				loop(name)
#			{:recieveMessage, message} -> 
#				IO.puts("#{name} -  Recibi: #{message}")
		end
	end
end


#Main

IO.puts("Sample Peer to Peer communication:")

pid = Talker.start()
send(pid, {:talk, "Pedro"})
send(pid, {:silenciar})
send(pid, {:talk, "Juan"})
send(pid, {:silenciar})
send(pid, {:talk, "Ana"})

:timer.sleep(50)
IO.puts("Group Chat communication:")

map = %{}
chatPid = GroupChat.start(map)

memberPid = GroupMember.start("Leo")

send(memberPid, {:subscribe, chatPid, memberPid})

#chatPid = ChatGrupal.start()

 
#send(chatPid, {subscribe})

