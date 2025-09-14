{
  networking.hostName = "tailnet01";
  networking.domain = "vfd.ovh";

  networking.useDHCP = false;

  networking.interfaces.enp0s5.ipv4.addresses = [
    {
      address = "192.168.10.199";
      prefixLength = 24;
    }
  ];

  networking.defaultGateway = {
    address = "192.168.10.254";
    interface = "enp0s5";
  };

  networking.nameservers = [
    "1.1.1.3"
    "1.0.0.3"
  ];
}
