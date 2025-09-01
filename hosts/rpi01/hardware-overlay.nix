{
  hardware.deviceTree = {
    overlays = [
      {
        name = "pwm-overlay";
        dtsText = ''
          /dts-v1/;
          /plugin/;
          / {
            compatible = "brcm,bcm2711";

            fragment@0 {
              target = <&gpio>;
              __overlay__ {
                pwm_pins: pwm_pins {
                  brcm,pins = <18>;
                  brcm,function = <2>; /* Alt5 */
                };
              };
            };

            fragment@1 {
              target = <&pwm>;
              __overlay__ {
                pinctrl-names = "default";
                assigned-clock-rates = <100000000>;
                status = "okay";
                pinctrl-0 = <&pwm_pins>;
              };
            };

          };
        '';
      }
      {
        name = "enable-xhci";
        dtsText = ''
          /dts-v1/;
          /plugin/;

          / {
            compatible = "brcm,bcm2711";
            fragment@0 {
              //target-path = "/scb/xhci@7e9c0000";
              target = <&xhci>;
              __overlay__ {
                status = "okay";
              };
            };
          };
        '';
      }
    ];
  };
}
