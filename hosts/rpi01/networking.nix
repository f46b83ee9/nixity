{
  networking.hostName = "rpi01";
  networking.domain = "vfd.ovh";

  networking.useDHCP = false;

  networking.interfaces.eth0.ipv4.addresses = [
    {
      address = "192.168.10.177";
      prefixLength = 24;
    }
  ];

  networking.defaultGateway = {
    address = "192.168.10.254";
    interface = "eth0";
  };

  networking.nameservers = [
    "192.168.10.253"
  ];
}
