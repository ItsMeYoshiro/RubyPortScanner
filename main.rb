require 'socket'
require 'timeout'

TIMEOUT = 1

def main
  system("clear")
  print "Informe o endereço IP ou hostname do alvo do Scan: "
  target = gets.chomp

  print "Informe qual porta você deseja começar o Scan: "
  port_init = gets.chomp.to_i

  print "Informe qual porta você deseja finalizar o Scan: "
  port_end = gets.chomp.to_i

  port_scan(target, port_init, port_end)
end

def port_scan(target, port_init, port_end)
    begin
        ip = Socket.getaddrinfo(target, nil)[0][3]

        puts "-" * 50
        puts "Alvo do Scan: #{ip}"
        puts "Inicio em: #{Time.now}"
        puts "-" * 50

        for port in port_init..port_end
          socket      = Socket.new(:INET, :STREAM)
          remote_addr = Socket.sockaddr_in(port, target)
          begin
            socket.connect_nonblock(remote_addr)
          rescue Errno::EINPROGRESS
          end
          _, sockets, _ = IO.select(nil, [socket], nil, TIMEOUT)
          if sockets
            service_name = Socket.getservbyport(port.to_i)
            puts "[!] Porta #{port} está aberta e executando #{service_name}."
          else
            puts "[-] Porta #{port} está fechada."
          end
        end

    rescue SocketError
        puts "Host não encontrado."
    end
end

main
