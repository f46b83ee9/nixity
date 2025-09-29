{
  networking.hostName = "thin01";
  networking.domain = "vfd.ovh";

  networking.useDHCP = false;

  networking.interfaces.enp1s0.ipv4.addresses = [
    {
      address = "192.168.10.188";
      prefixLength = 24;
    }
  ];

  networking.defaultGateway = {
    address = "192.168.10.254";
    interface = "enp1s0";
  };

  networking.nameservers = [
    "192.168.10.253"
  ];
}
