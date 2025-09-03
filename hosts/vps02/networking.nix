{
  networking.hostName = "vps02";
  networking.domain = "vfd.ovh";

  networking.useDHCP = false;

  networking.interfaces.ens3.ipv4.addresses = [
    {
      address = "51.75.252.175";
      prefixLength = 32;
    }
  ];

  networking.defaultGateway = {
    address = "51.77.156.1";
    interface = "ens3";
  };

  networking.interfaces.ens3.ipv6.addresses = [
    {
      address = "2001:41d0:305:2100::4a84";
      prefixLength = 128;
    }
  ];

  networking.defaultGateway6 = {
    address = "2001:41d0:305:2100::1";
    interface = "ens3";
  };

  networking.nameservers = [
    "1.1.1.3"
    "1.0.0.3"
    "2606:4700:4700::1113"
    "2606:4700:4700::1003"
  ];
}
