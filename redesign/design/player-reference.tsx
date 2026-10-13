const imgFrame1 = "ASSET:851a2883.svg";
const imgFrame17 = "ASSET:8c357183.svg";
const imgFrame18 = "ASSET:1ed6d49e.svg";
const imgFrame = "ASSET:2c1b31ea.svg";
const imgFrame2 = "ASSET:8cbecc6f.svg";
const imgRectangle6 = "ASSET:6df407de.svg";
const imgRectangle7 = "ASSET:cda036bc.svg";
const imgRectangle8 = "ASSET:6dc4bac4.svg";
const imgPlayer = "ASSET:e0bac7f3.png";
const imgFrame29 = "ASSET:2858e98f.png";
const imgFrame30 = "ASSET:18c2353b.png";
const imgFrame31 = "ASSET:52cf9ced.png";
const imgFrame32 = "ASSET:7396d1de.png";
const imgFrame33 = "ASSET:47317d6e.png";
const imgFrame34 = "ASSET:b414a33d.png";
const imgFrame35 = "ASSET:55b0ce7c.png";
const imgFrame36 = "ASSET:d69a421a.png";
const imgFrame37 = "ASSET:77478ee7.png";
const imgFrame38 = "ASSET:161b4673.png";
const imgFrame39 = "ASSET:b286c408.png";
const imgFrame40 = "ASSET:a480e009.png";
const imgFrame41 = "ASSET:fd847dff.png";
const imgFrame42 = "ASSET:db5c52a4.png";
const imgFrame43 = "ASSET:b1f9d9c8.png";
const imgFrame44 = "ASSET:4ae3bcb5.png";
const imgFrame4 = "ASSET:891d1664.svg";
const imgFrame49 = "ASSET:27df51c9.svg";
const imgFrame3 = "ASSET:175b0351.svg";
const imgFrame5 = "ASSET:7caf945b.svg";
const imgFrame6 = "ASSET:261a48a0.svg";
const imgFrame7 = "ASSET:3d77c77e.svg";
const imgFrame8 = "ASSET:b4b66951.svg";
const imgFrame9 = "ASSET:9bea253f.svg";
const imgFrame10 = "ASSET:19e4d867.svg";
const imgFrame11 = "ASSET:24879317.svg";
const imgFrame12 = "ASSET:b295f642.svg";
const imgFrame13 = "ASSET:82dad7fa.svg";
const imgFrame14 = "ASSET:6ebea2f9.svg";
const imgFrame15 = "ASSET:5aa72967.svg";
const imgFrame16 = "ASSET:ef0f8620.svg";
const imgFrame19 = "ASSET:8ba31cbd.svg";
const imgFrame20 = "ASSET:af94d7a6.svg";
const imgFrame21 = "ASSET:7cd64393.svg";
const imgFrame22 = "ASSET:1e00c8cc.svg";
const imgFrame23 = "ASSET:abc1530f.svg";
const imgFrame24 = "ASSET:8f7825d7.svg";
const imgFrame50 = "ASSET:4962afe3.svg";
const imgFrame25 = "ASSET:d14b52a0.svg";
const imgFrame26 = "ASSET:647b76f6.svg";
const imgFrame27 = "ASSET:52cb4f13.svg";
const imgFrame28 = "ASSET:71e0ed00.svg";
const imgVector = "ASSET:fb4973de.svg";

type IconProps = {
  className?: string;
  direction?: "default" | "right" | "left";
  eq?: "default";
  name?: "settings" | "next" | "previous" | "arrow";
  state?: "default";
  twoTone?: boolean;
  value?: "default";
};

function Icon({ className, direction = "default", eq = "default", name = "settings", state = "default", twoTone = false, value = "default" }: IconProps) {
  const isArrowAndDefaultAndFalseAndIsRightOrLeft = name === "arrow" && eq === "default" && !twoTone && ["right", "left"].includes(direction);
  const isArrowAndLeftAndDefaultAndFalse = name === "arrow" && direction === "left" && eq === "default" && !twoTone;
  const isArrowAndRightAndDefaultAndFalse = name === "arrow" && direction === "right" && eq === "default" && !twoTone;
  const isNextAndDefaultAndDefaultAndFalse = name === "next" && direction === "default" && eq === "default" && !twoTone;
  const isPreviousAndDefaultAndDefaultAndFalse = name === "previous" && direction === "default" && eq === "default" && !twoTone;
  return (
    <div c={className || `content-stretch flex items-center justify-center relative ${direction === "default" && eq === "default" && !twoTone && ["next", "previous"].includes(name) ? "size-[24px]" : ""}`} id={isArrowAndLeftAndDefaultAndFalse ? "node-71_890" : isArrowAndRightAndDefaultAndFalse ? "node-71_887" : isPreviousAndDefaultAndDefaultAndFalse ? "node-45_18" : isNextAndDefaultAndDefaultAndFalse ? "node-45_12" : "node-42_355"}>
      <div c={`relative shrink-0 ${isArrowAndDefaultAndFalseAndIsRightOrLeft ? "flex items-center justify-center" : "size-[24px]"}`} id={isArrowAndLeftAndDefaultAndFalse ? "node-71_891" : isArrowAndRightAndDefaultAndFalse ? "node-71_888" : isPreviousAndDefaultAndDefaultAndFalse ? "node-177_83" : isNextAndDefaultAndDefaultAndFalse ? "node-177_79" : "node-44_413"}>
        {direction === "default" && eq === "default" && !twoTone && ["settings", "next", "previous"].includes(name) && <img alt="" c="absolute block inset-0 max-w-none size-full" src={name === "previous" && eq === "default" && !twoTone ? imgFrame18 : name === "next" && eq === "default" && !twoTone ? imgFrame17 : imgFrame1} />}
        {isArrowAndDefaultAndFalseAndIsRightOrLeft && (
          <div c="-scale-y-100 flex-none rotate-180">
            <div c="relative size-[24px]" data-name="Frame">
              <img alt="" c="absolute block inset-0 max-w-none size-full" src={direction === "left" && eq === "default" && !twoTone ? imgFrame2 : imgFrame} />
            </div>
          </div>
        )}
      </div>
    </div>
  );
}

type VolumeProps = {
  className?: string;
  property1?: "50%";
};

function Volume({ className, property1 = "50%" }: VolumeProps) {
  return (
    <div c={className || "h-[28px] relative w-[88px]"} data-node-id="244:210">
      <div c="-translate-x-1/2 -translate-y-1/2 absolute h-[28px] left-[calc(50%+0.5px)] top-1/2 w-[89px]" data-node-id="244:211">
        <div c="absolute inset-[1.14%_0]">
          <img alt="" c="block max-w-none size-full" src={imgRectangle6} />
        </div>
      </div>
      <div c="-translate-x-1/2 -translate-y-1/2 absolute contents left-[calc(50%-27.5px)] top-1/2" data-node-id="244:212">
        <div c="-translate-x-1/2 -translate-y-1/2 absolute h-[25px] left-[calc(50%+0.5px)] mask-alpha mask-intersect mask-no-clip mask-no-repeat mask-position-[-1.5px_-2.5px] mask-size-[33px_30px] top-1/2 w-[86px]" data-node-id="244:214" style={{ maskImage: `url("${imgRectangle7}")` }}>
          <div c="absolute inset-[0.88%_0]">
            <img alt="" c="block max-w-none size-full" src={imgRectangle8} />
          </div>
        </div>
      </div>
    </div>
  );
}

type DurationProps = {
  className?: string;
  state?: "Default";
};

function Duration({ className, state = "Default" }: DurationProps) {
  return (
    <button c={className || "content-stretch flex h-[28px] items-center justify-center px-[8px] py-[2px] relative rounded-[6px] w-[76px]"} data-node-id="1905:7313">
      <p c="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#8f8f8f] text-[15px] text-left whitespace-nowrap" data-node-id="1905:7314">
        00:25:40
      </p>
    </button>
  );
}

type CurrentTimeProps = {
  className?: string;
  state?: "Default";
};

function CurrentTime({ className, state = "Default" }: CurrentTimeProps) {
  return (
    <div c={className || "content-stretch flex h-[28px] items-center justify-center px-[8px] py-[2px] relative rounded-[6px] w-[76px]"} data-node-id="1904:7237">
      <p c="[word-break:break-word] font-['Inter:Regular'] font-normal h-[17px] leading-[normal] not-italic relative shrink-0 text-[#8f8f8f] text-[15px] w-[63px]" data-node-id="1904:7236">
        00:02:10
      </p>
    </div>
  );
}

export default function Player() {
  return (
    <div c="content-stretch flex flex-col isolate items-start justify-between relative size-full" data-node-id="247:445" data-name="Player">
      <div aria-hidden c="absolute inset-0 pointer-events-none">
        <div c="absolute bg-[#1b1b1b] inset-0" />
        <img alt="" c="absolute max-w-none object-cover size-full" src={imgPlayer} />
      </div>
      <div c="content-stretch flex flex-[1_0_0] flex-col items-center justify-between min-h-px relative w-full z-[1]" data-node-id="286:264">
        <div c="absolute backdrop-blur-[25px] border-20 border-[#1b1b1b] border-solid content-stretch flex h-[1005px] items-start left-0 p-[10px] rounded-[19px] top-[31px] w-[1920px]" data-node-id="6586:17371" />
        <div c="backdrop-blur-[25px] bg-[#1b1b1b] content-stretch flex h-[40px] items-center justify-between overflow-clip p-[6px] relative shrink-0 w-full" data-node-id="247:447" data-name="topbar">
          <div c="content-stretch flex gap-[7px] items-center relative shrink-0 w-[300px]" data-node-id="247:448">
            <div c="content-stretch flex items-center justify-center px-[7px] py-[2px] relative shrink-0" data-node-id="247:449">
              <div c="content-stretch flex items-center justify-center relative shrink-0 size-[24px]" data-node-id="247:450" data-name="Icon">
                <div c="relative shrink-0 size-[24px]" data-node-id="I247:450;51:798">
                  <img alt="" c="absolute block inset-0 max-w-none size-full" src={imgFrame4} />
                </div>
              </div>
            </div>
            <div c="content-stretch flex items-center relative shrink-0" data-node-id="247:451">
              <div c="content-stretch cursor-pointer flex gap-[10px] items-center relative shrink-0" data-node-id="247:452">
                <button c="content-stretch flex items-center justify-center p-[2px] relative shrink-0" data-node-id="247:454" data-name="Icon">
                  <div c="flex items-center justify-center relative shrink-0" data-node-id="I247:454;247:419">
                    <div c="-scale-y-100 flex-none rotate-180">
                      <div c="relative size-[24px]" data-name="Frame">
                        <div c="-translate-x-1/2 -translate-y-1/2 absolute left-1/2 size-[18px] top-1/2" data-node-id="I247:454;247:420">
                          <img alt="" c="absolute block inset-0 max-w-none size-full" src={imgFrame49} />
                        </div>
                      </div>
                    </div>
                  </div>
                </button>
                <a c="content-stretch flex items-center justify-center p-[2px] relative shrink-0" data-node-id="247:456" data-name="Icon">
                  <div c="flex items-center justify-center relative shrink-0" data-node-id="I247:456;69:815">
                    <div c="-scale-y-100 flex-none rotate-180">
                      <div c="relative size-[24px]" data-name="Frame">
                        <img alt="" c="absolute block inset-0 max-w-none size-full" src={imgFrame3} />
                      </div>
                    </div>
                  </div>
                </a>
              </div>
              <div c="content-stretch flex items-center justify-center py-[2px] relative shrink-0" data-node-id="247:457">
                <div c="content-stretch flex items-center justify-center relative shrink-0" data-node-id="247:458" data-name="Icon">
                  <div c="flex items-center justify-center relative shrink-0" data-node-id="I247:458;71:864">
                    <div c="-scale-y-100 flex-none rotate-180">
                      <div c="relative size-[24px]" data-name="Frame">
                        <img alt="" c="absolute block inset-0 max-w-none size-full" src={imgFrame5} />
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <a c="content-stretch cursor-pointer flex gap-[4px] items-center pr-[4px] relative rounded-[6px] shrink-0" data-node-id="247:459">
                <div c="content-stretch flex items-center justify-center p-[2px] relative shrink-0" data-node-id="247:461" data-name="Icon">
                  <div c="flex items-center justify-center relative shrink-0" data-node-id="I247:461;51:809">
                    <div c="-scale-y-100 flex-none rotate-180">
                      <div c="relative size-[24px]" data-name="Frame">
                        <img alt="" c="absolute block inset-0 max-w-none size-full" src={imgFrame6} />
                      </div>
                    </div>
                  </div>
                </div>
                <p c="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#8f8f8f] text-[14px] text-left whitespace-nowrap" data-node-id="247:462">
                  Videos
                </p>
              </a>
            </div>
          </div>
          <p c="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#8f8f8f] text-[14px] whitespace-nowrap" data-node-id="247:463">
            VLC Media Player
          </p>
          <div c="content-stretch flex items-center justify-end relative shrink-0 w-[300px]" data-node-id="247:464">
            <div c="content-stretch flex items-center justify-center px-[6px] relative shrink-0" data-node-id="247:466" data-name="Icon">
              <div c="flex items-center justify-center relative shrink-0" data-node-id="I247:466;48:47">
                <div c="-scale-y-100 flex-none rotate-180">
                  <div c="relative size-[24px]" data-name="Frame">
                    <img alt="" c="absolute block inset-0 max-w-none size-full" src={imgFrame7} />
                  </div>
                </div>
              </div>
            </div>
            <div c="content-stretch flex items-center justify-center px-[6px] relative shrink-0" data-node-id="247:467" data-name="Icon">
              <div c="flex items-center justify-center relative shrink-0" data-node-id="I247:467;48:52">
                <div c="-scale-y-100 flex-none rotate-180">
                  <div c="relative size-[24px]" data-name="Frame">
                    <img alt="" c="absolute block inset-0 max-w-none size-full" src={imgFrame8} />
                  </div>
                </div>
              </div>
            </div>
            <div c="content-stretch flex items-center justify-center px-[6px] relative shrink-0" data-node-id="247:468" data-name="Icon">
              <div c="flex items-center justify-center relative shrink-0" data-node-id="I247:468;48:55">
                <div c="-scale-y-100 flex-none rotate-180">
                  <div c="relative size-[24px]" data-name="Frame">
                    <img alt="" c="absolute block inset-0 max-w-none size-full" src={imgFrame9} />
                  </div>
                </div>
              </div>
            </div>
            <div c="content-stretch flex items-center justify-center px-[6px] relative shrink-0" data-node-id="247:469" data-name="Icon">
              <div c="flex items-center justify-center relative shrink-0" data-node-id="I247:469;45:41">
                <div c="-scale-y-100 flex-none rotate-180">
                  <div c="relative size-[24px]" data-name="Frame">
                    <img alt="" c="absolute block inset-0 max-w-none size-full" src={imgFrame10} />
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div c="backdrop-blur-[25px] bg-[#1b1b1b] content-stretch flex gap-[20px] h-[54px] items-center overflow-clip px-[20px] py-[11px] relative shrink-0 w-full" data-node-id="491:1928" data-name="Controls">
          <div c="content-stretch flex gap-[8px] items-center relative shrink-0" data-node-id="I491:1928;3603:12301">
            <div c="content-stretch flex items-center justify-center px-[3px] py-[2px] relative shrink-0" data-node-id="I491:1928;3603:12302">
              <Icon c="content-stretch flex items-center justify-center relative shrink-0 size-[24px]" name="previous" />
            </div>
            <button c="bg-[#d37918] content-stretch cursor-pointer flex items-center justify-center pl-[17px] pr-[15px] py-[2px] relative rounded-[6px] shrink-0 w-[54px]" data-node-id="I491:1928;3603:12304" data-name="play">
              <div c="content-stretch flex items-center justify-center relative shrink-0" data-node-id="I491:1928;3603:12304;848:1707" data-name="Icon">
                <div c="relative shrink-0 size-[24px]" data-node-id="I491:1928;3603:12304;848:1707;44:420" data-name="Frame">
                  <img alt="" c="absolute block inset-0 max-w-none size-full" src={imgFrame11} />
                </div>
              </div>
            </button>
            <div c="content-stretch flex items-center justify-center px-[3px] py-[2px] relative shrink-0" data-node-id="I491:1928;3603:12305">
              <Icon c="content-stretch flex items-center justify-center relative shrink-0 size-[24px]" name="next" />
            </div>
          </div>
          <button c="content-stretch cursor-pointer flex flex-[1_0_0] gap-[8px] items-center justify-center min-w-px relative" data-node-id="I491:1928;1908:7385">
            <CurrentTime c="content-stretch flex h-[28px] items-center justify-center px-[8px] py-[2px] relative rounded-[6px] shrink-0 w-[76px]" />
            <div c="bg-[#090909] flex-[1_0_0] h-[28px] min-w-px relative rounded-[6px]" data-node-id="I491:1928;1908:7387">
              <div c="absolute bg-[#371f06] h-[24px] left-[2px] rounded-[4px] top-[2px] w-[98px]" data-node-id="I491:1928;1908:7388" />
              <div c="absolute bg-[#d37918] h-[24px] left-[92px] rounded-[4px] top-[2px] w-[8px]" data-node-id="I491:1928;1908:7389" />
            </div>
            <Duration c="content-stretch flex h-[28px] items-center justify-center px-[8px] py-[2px] relative rounded-[6px] shrink-0 w-[76px]" />
          </button>
          <div c="content-stretch flex gap-[8px] items-center justify-end relative shrink-0" data-node-id="I491:1928;491:1731">
            <div c="content-stretch flex items-center justify-center relative shrink-0" data-node-id="I491:1928;491:1732" data-name="Icon">
              <div c="flex items-center justify-center relative shrink-0" data-node-id="I491:1928;491:1732;182:180">
                <div c="-scale-y-100 flex-none rotate-180">
                  <div c="relative size-[24px]" data-name="Frame">
                    <img alt="" c="absolute block inset-0 max-w-none size-full" src={imgFrame12} />
                  </div>
                </div>
              </div>
            </div>
            <Volume c="h-[28px] relative shrink-0 w-[88px]" />
          </div>
          <div c="content-stretch cursor-pointer flex gap-[12px] items-center relative shrink-0" data-node-id="I491:1928;491:1728">
            <button c="content-stretch flex items-center justify-center p-[4px] relative rounded-[4px] shrink-0 w-[30px]" data-node-id="I491:1928;496:2470" data-name="Icon Wrapper">
              <div c="content-stretch flex items-center justify-center relative shrink-0" data-node-id="I491:1928;496:2470;177:88" data-name="Icon">
                <div c="relative shrink-0 size-[24px]" data-node-id="I491:1928;496:2470;177:88;44:408" data-name="Frame">
                  <img alt="" c="absolute block inset-0 max-w-none size-full" src={imgFrame13} />
                </div>
              </div>
            </button>
            <button c="content-stretch flex items-center justify-center p-[4px] relative rounded-[4px] shrink-0 w-[30px]" data-node-id="I491:1928;491:1730" data-name="Icon Wrapper">
              <div c="content-stretch flex items-center justify-center relative shrink-0" data-node-id="I491:1928;491:1730;177:88" data-name="Icon">
                <div c="relative shrink-0 size-[24px]" data-node-id="I491:1928;491:1730;177:88;42:399" data-name="Frame">
                  <img alt="" c="absolute block inset-0 max-w-none size-full" src={imgFrame14} />
                </div>
              </div>
            </button>
            <button c="content-stretch flex items-center justify-center p-[4px] relative rounded-[4px] shrink-0 w-[30px]" data-node-id="I491:1928;491:1729" data-name="Icon Wrapper">
              <div c="content-stretch flex items-center justify-center relative shrink-0" data-node-id="I491:1928;491:1729;177:88" data-name="Icon">
                <div c="relative shrink-0 size-[24px]" data-node-id="I491:1928;491:1729;177:88;2230:9223">
                  <img alt="" c="absolute block inset-0 max-w-none size-full" src={imgFrame15} />
                </div>
              </div>
            </button>
          </div>
          <button c="content-stretch cursor-pointer flex items-center justify-center p-[4px] relative rounded-[4px] shrink-0 w-[30px]" data-node-id="I491:1928;491:1734" data-name="Icon Wrapper">
            <div c="content-stretch flex items-center justify-center relative shrink-0" data-node-id="I491:1928;491:1734;177:88" data-name="Icon">
              <div c="relative shrink-0 size-[24px]" data-node-id="I491:1928;491:1734;177:88;217:192" data-name="Frame">
                <img alt="" c="absolute block inset-0 max-w-none size-full" src={imgFrame16} />
              </div>
            </div>
          </button>
        </div>
        <div c="absolute content-stretch flex h-[986px] items-start left-[-437px] top-[40px] w-[427px]" data-node-id="856:2587" data-name="sidebar">
          <div c="bg-[#191919] content-stretch cursor-pointer flex flex-col gap-[14px] h-full items-center overflow-clip p-[8px] relative shrink-0 w-[50px]" data-node-id="I856:2587;848:1867">
            <button c="content-stretch flex items-center justify-center p-[4px] relative rounded-[4px] shrink-0 w-[30px]" data-node-id="I856:2587;848:1868" data-name="Icon Wrapper">
              <div c="content-stretch flex items-center justify-center relative shrink-0" data-node-id="I856:2587;848:1868;177:88" data-name="Icon">
                <div c="flex items-center justify-center relative shrink-0" data-node-id="I856:2587;848:1868;177:88;70:829">
                  <div c="-scale-y-100 flex-none rotate-180">
                    <div c="relative size-[24px]" data-name="Frame">
                      <img alt="" c="absolute block inset-0 max-w-none size-full" src={imgFrame19} />
                    </div>
                  </div>
                </div>
              </div>
            </button>
            <button c="content-stretch flex items-center justify-center p-[4px] relative rounded-[4px] shrink-0" data-node-id="I856:2587;848:1869" data-name="Icon Wrapper">
              <div c="content-stretch flex items-center justify-center relative shrink-0" data-node-id="I856:2587;848:1869;177:88" data-name="Icon">
                <div c="flex items-center justify-center relative shrink-0" data-node-id="I856:2587;848:1869;177:88;470:588">
                  <div c="-scale-y-100 flex-none rotate-180">
                    <div c="relative size-[24px]" data-name="Frame">
                      <img alt="" c="absolute block inset-0 max-w-none size-full" src={imgFrame20} />
                    </div>
                  </div>
                </div>
              </div>
            </button>
            <button c="content-stretch flex items-center justify-center p-[4px] relative rounded-[4px] shrink-0 w-[30px]" data-node-id="I856:2587;848:1870" data-name="Icon Wrapper">
              <div c="content-stretch flex items-center justify-center relative shrink-0" data-node-id="I856:2587;848:1870;177:88" data-name="Icon">
                <div c="relative shrink-0 size-[24px]" data-node-id="I856:2587;848:1870;177:88;44:413">
                  <img alt="" c="absolute block inset-0 max-w-none size-full" src={imgFrame1} />
                </div>
              </div>
            </button>
            <button c="content-stretch flex items-center justify-center p-[4px] relative rounded-[4px] shrink-0 w-[30px]" data-node-id="I856:2587;848:1871" data-name="Icon Wrapper">
              <div c="content-stretch flex flex-col items-center justify-center relative shrink-0 size-[24px]" data-node-id="I856:2587;848:1871;177:88" data-name="Icon">
                <div c="flex items-center justify-center relative shrink-0" data-node-id="I856:2587;848:1871;177:88;70:834">
                  <div c="-scale-y-100 flex-none rotate-180">
                    <div c="relative size-[24px]" data-name="Frame">
                      <img alt="" c="absolute block inset-0 max-w-none size-full" src={imgFrame21} />
                    </div>
                  </div>
                </div>
              </div>
            </button>
            <button c="content-stretch flex items-center justify-center p-[4px] relative rounded-[4px] shrink-0 w-[30px]" data-node-id="I856:2587;858:5132" data-name="Icon Wrapper">
              <div c="content-stretch flex items-center justify-center relative shrink-0" data-node-id="I856:2587;858:5132;177:88" data-name="Icon">
                <div c="relative shrink-0 size-[24px]" data-node-id="I856:2587;858:5132;177:88;42:362" data-name="Frame">
                  <img alt="" c="absolute block inset-0 max-w-none size-full" src={imgFrame22} />
                </div>
              </div>
            </button>
            <button c="content-stretch flex items-center justify-center p-[4px] relative rounded-[4px] shrink-0 w-[30px]" data-node-id="I856:2587;2154:9703" data-name="Icon Wrapper">
              <div c="content-stretch flex items-center justify-center relative shrink-0" data-node-id="I856:2587;2154:9703;177:88" data-name="Icon">
                <div c="flex items-center justify-center relative shrink-0" data-node-id="I856:2587;2154:9703;177:88;2154:9700">
                  <div c="-scale-y-100 flex-none rotate-180">
                    <div c="relative size-[24px]" data-name="Frame">
                      <img alt="" c="absolute block inset-0 max-w-none size-full" src={imgFrame23} />
                    </div>
                  </div>
                </div>
              </div>
            </button>
            <button c="content-stretch flex items-center justify-center p-[4px] relative rounded-[4px] shrink-0 w-[30px]" data-node-id="I856:2587;1105:5493" data-name="Icon Wrapper">
              <div c="content-stretch flex items-center justify-center relative shrink-0" data-node-id="I856:2587;1105:5493;177:88" data-name="Icon">
                <div c="relative shrink-0 size-[24px]" data-node-id="I856:2587;1105:5493;177:88;463:551">
                  <img alt="" c="absolute block inset-0 max-w-none size-full" src={imgFrame24} />
                </div>
              </div>
            </button>
          </div>
          <div c="backdrop-blur-[25px] bg-[rgba(14,14,14,0.95)] content-stretch flex flex-[1_0_0] flex-col gap-[17px] h-full items-center min-w-px overflow-clip p-[20px] relative" data-node-id="I856:2587;848:1872">
            <div c="content-stretch flex flex-col gap-[20px] items-start relative shrink-0 w-full" data-node-id="I856:2587;848:1873">
              <div c="content-stretch flex gap-[10px] items-center relative shrink-0 w-full" data-node-id="I856:2587;848:1874">
                <div c="content-stretch flex gap-[12px] items-center relative shrink-0" data-node-id="I856:2587;848:1875">
                  <Icon c="content-stretch cursor-pointer flex items-center justify-center relative shrink-0" direction="left" name="arrow" />
                  <Icon c="content-stretch flex items-center justify-center opacity-30 relative shrink-0" direction="right" name="arrow" />
                </div>
                <div c="[word-break:break-word] content-stretch flex flex-[1_0_0] font-['Inter:Regular'] font-normal gap-[6px] items-center leading-[0] min-w-px not-italic relative" data-node-id="I856:2587;6131:13527">
                  <button c="cursor-pointer flex flex-col justify-center relative shrink-0 text-[#8f8f8f] text-[16px] text-left whitespace-nowrap" data-node-id="I856:2587;6131:13671">
                    <p c="leading-[normal]">...</p>
                  </button>
                  <div c="flex flex-col h-full justify-center relative shrink-0 text-[#404040] text-[8px] w-[8px]">
                    <p c="leading-[normal]">▶</p>
                  </div>
                  <button c="cursor-pointer flex flex-col justify-center relative shrink-0 text-[#8f8f8f] text-[16px] text-left whitespace-nowrap" data-node-id="I856:2587;848:1878">
                    <p c="leading-[normal]">The Wand</p>
                  </button>
                  <div c="flex flex-col h-full justify-center relative shrink-0 text-[#404040] text-[8px] w-[8px]">
                    <p c="leading-[normal]">▶</p>
                  </div>
                  <div c="flex flex-col justify-center relative shrink-0 text-[#8f8f8f] text-[16px] whitespace-nowrap" data-node-id="I856:2587;6131:13646">
                    <p c="leading-[normal]">S01</p>
                  </div>
                </div>
                <div c="content-stretch cursor-pointer flex gap-[12px] items-center justify-end relative shrink-0" data-node-id="I856:2587;1851:3228">
                  <button c="content-stretch flex items-center justify-center relative shrink-0" data-node-id="I856:2587;1851:3229" data-name="Icon">
                    <div c="flex items-center justify-center relative shrink-0" data-node-id="I856:2587;1851:3229;247:419">
                      <div c="-scale-y-100 flex-none rotate-180">
                        <div c="relative size-[24px]" data-name="Frame">
                          <div c="-translate-x-1/2 -translate-y-1/2 absolute left-1/2 size-[18px] top-1/2" data-node-id="I856:2587;1851:3229;247:420">
                            <img alt="" c="absolute block inset-0 max-w-none size-full" src={imgFrame50} />
                          </div>
                        </div>
                      </div>
                    </div>
                  </button>
                  <a c="content-stretch flex items-center justify-center relative shrink-0" data-node-id="I856:2587;1851:3230" data-name="Icon">
                    <div c="flex items-center justify-center relative shrink-0" data-node-id="I856:2587;1851:3230;330:268">
                      <div c="-scale-y-100 flex-none rotate-180">
                        <div c="relative size-[24px]" data-name="Frame">
                          <img alt="" c="absolute block inset-0 max-w-none size-full" src={imgFrame25} />
                        </div>
                      </div>
                    </div>
                  </a>
                </div>
              </div>
              <div c="content-stretch flex h-[24px] items-center justify-between relative shrink-0 w-full" data-node-id="I856:2587;2139:8515">
                <p c="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#6b6b6b] text-[14px] whitespace-nowrap" data-node-id="I856:2587;2139:8516">
                  15 items
                </p>
                <div c="content-stretch flex gap-[12px] items-center justify-end relative shrink-0" data-node-id="I856:2587;2139:8517">
                  <button c="content-stretch cursor-pointer flex items-center justify-center relative shrink-0" data-node-id="I856:2587;2139:8518" data-name="Icon">
                    <div c="relative shrink-0 size-[24px]" data-node-id="I856:2587;2139:8518;856:2207">
                      <div c="absolute inset-[-4.17%_-8.33%_0_0]">
                        <img alt="" c="block max-w-none size-full" src={imgFrame26} />
                      </div>
                    </div>
                  </button>
                  <button c="content-stretch cursor-pointer flex items-center justify-center relative shrink-0" data-node-id="I856:2587;2139:8519" data-name="Icon">
                    <div c="relative shrink-0 size-[24px]" data-node-id="I856:2587;2139:8519;2107:6532">
                      <img alt="" c="absolute block inset-0 max-w-none size-full" src={imgFrame27} />
                    </div>
                  </button>
                  <div c="content-stretch flex items-center justify-center relative shrink-0" data-node-id="I856:2587;2139:8520" data-name="Icon">
                    <div c="relative shrink-0 size-[24px]" data-node-id="I856:2587;2139:8520;856:2148">
                      <img alt="" c="absolute block inset-0 max-w-none size-full" src={imgFrame28} />
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div c="content-stretch flex flex-col items-start relative shrink-0 w-full" data-node-id="I856:2587;6784:16223">
              <div c="h-0 relative shrink-0 w-full" data-node-id="I856:2587;6784:16224" data-name="Vector">
                <div c="absolute inset-[-0.5px_0]">
                  <img alt="" c="block max-w-none size-full" src={imgVector} />
                </div>
              </div>
              <div c="content-stretch flex flex-col gap-[10px] h-[888px] items-center py-[20px] relative shrink-0 w-full" data-node-id="I856:2587;6784:16225">
                <div c="content-stretch flex gap-[10px] items-center relative shrink-0 w-[337px]" data-node-id="I856:2587;6784:16226" data-name="media">
                  <div c="content-stretch flex items-center justify-center relative shrink-0 size-[32px]" data-node-id="I856:2587;6784:16226;2404:9180" data-name="Icon">
                    <div c="content-stretch flex flex-[1_0_0] h-full items-center min-w-px relative" data-node-id="I856:2587;6784:16226;2404:9180;2404:9199">
                      <div c="content-stretch flex flex-[1_0_0] flex-col h-full items-start min-w-px p-[10px] relative rounded-[2px]" data-node-id="I856:2587;6784:16226;2404:9180;2404:9202">
                        <img alt="" c="absolute inset-0 max-w-none object-cover pointer-events-none rounded-[2px] size-full" src={imgFrame29} />
                      </div>
                    </div>
                  </div>
                  <p c="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[normal] min-w-px not-italic relative text-[#8f8f8f] text-[14px]" data-node-id="I856:2587;6784:16226;2404:9181">
                    The_Wand_S01E05.mp4
                  </p>
                </div>
                <div c="content-stretch flex gap-[10px] items-center relative shrink-0 w-[337px]" data-node-id="I856:2587;6784:16228" data-name="media">
                  <div c="content-stretch flex items-center justify-center relative shrink-0 size-[32px]" data-node-id="I856:2587;6784:16228;2404:9180" data-name="Icon">
                    <div c="content-stretch flex flex-[1_0_0] h-full items-center min-w-px relative" data-node-id="I856:2587;6784:16228;2404:9180;2404:9199">
                      <div c="content-stretch flex flex-[1_0_0] flex-col h-full items-start min-w-px p-[10px] relative rounded-[2px]" data-node-id="I856:2587;6784:16228;2404:9180;2404:9202">
                        <div aria-hidden c="absolute inset-0 pointer-events-none rounded-[2px]">
                          <div c="absolute bg-[#303030] inset-0 rounded-[2px]" />
                          <img alt="" c="absolute max-w-none object-cover rounded-[2px] size-full" src={imgFrame30} />
                          <img alt="" c="absolute max-w-none object-cover rounded-[2px] size-full" src={imgFrame31} />
                        </div>
                      </div>
                    </div>
                  </div>
                  <p c="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[normal] min-w-px not-italic relative text-[#969696] text-[14px]" data-node-id="I856:2587;6784:16228;2404:9181">
                    The_Wand_S01E06.mp4
                  </p>
                </div>
                <div c="content-stretch flex gap-[10px] items-center relative shrink-0 w-[337px]" data-node-id="I856:2587;6784:16229" data-name="media">
                  <div c="content-stretch flex items-center justify-center relative shrink-0 size-[32px]" data-node-id="I856:2587;6784:16229;2404:9180" data-name="Icon">
                    <div c="content-stretch flex flex-[1_0_0] h-full items-center min-w-px relative" data-node-id="I856:2587;6784:16229;2404:9180;2404:9199">
                      <div c="content-stretch flex flex-[1_0_0] flex-col h-full items-start min-w-px p-[10px] relative rounded-[2px]" data-node-id="I856:2587;6784:16229;2404:9180;2404:9202">
                        <div aria-hidden c="absolute inset-0 pointer-events-none rounded-[2px]">
                          <div c="absolute bg-[#303030] inset-0 rounded-[2px]" />
                          <img alt="" c="absolute max-w-none object-cover rounded-[2px] size-full" src={imgFrame30} />
                          <img alt="" c="absolute max-w-none object-cover rounded-[2px] size-full" src={imgFrame32} />
                        </div>
                      </div>
                    </div>
                  </div>
                  <p c="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[normal] min-w-px not-italic relative text-[#969696] text-[14px]" data-node-id="I856:2587;6784:16229;2404:9181">
                    The_Wand_S01E07.mp4
                  </p>
                </div>
                <div c="content-stretch flex gap-[10px] items-center relative shrink-0 w-[337px]" data-node-id="I856:2587;6784:16230" data-name="media">
                  <div c="content-stretch flex items-center justify-center relative shrink-0 size-[32px]" data-node-id="I856:2587;6784:16230;2404:9180" data-name="Icon">
                    <div c="content-stretch flex flex-[1_0_0] h-full items-center min-w-px relative" data-node-id="I856:2587;6784:16230;2404:9180;2404:9199">
                      <div c="content-stretch flex flex-[1_0_0] flex-col h-full items-start min-w-px p-[10px] relative rounded-[2px]" data-node-id="I856:2587;6784:16230;2404:9180;2404:9202">
                        <div aria-hidden c="absolute inset-0 pointer-events-none rounded-[2px]">
                          <div c="absolute bg-[#303030] inset-0 rounded-[2px]" />
                          <img alt="" c="absolute max-w-none object-cover rounded-[2px] size-full" src={imgFrame30} />
                          <img alt="" c="absolute max-w-none object-cover rounded-[2px] size-full" src={imgFrame33} />
                        </div>
                      </div>
                    </div>
                  </div>
                  <p c="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[normal] min-w-px not-italic relative text-[#969696] text-[14px]" data-node-id="I856:2587;6784:16230;2404:9181">
                    The_Wand_S01E08.mp4
                  </p>
                </div>
                <div c="content-stretch flex gap-[10px] items-center relative shrink-0 w-[337px]" data-node-id="I856:2587;6784:16231" data-name="media">
                  <div c="content-stretch flex items-center justify-center relative shrink-0 size-[32px]" data-node-id="I856:2587;6784:16231;2404:9180" data-name="Icon">
                    <div c="content-stretch flex flex-[1_0_0] h-full items-center min-w-px relative" data-node-id="I856:2587;6784:16231;2404:9180;2404:9199">
                      <div c="content-stretch flex flex-[1_0_0] flex-col h-full items-start min-w-px p-[10px] relative rounded-[2px]" data-node-id="I856:2587;6784:16231;2404:9180;2404:9202">
                        <div aria-hidden c="absolute inset-0 pointer-events-none rounded-[2px]">
                          <div c="absolute bg-[#303030] inset-0 rounded-[2px]" />
                          <img alt="" c="absolute max-w-none object-cover rounded-[2px] size-full" src={imgFrame30} />
                          <img alt="" c="absolute max-w-none object-cover rounded-[2px] size-full" src={imgFrame34} />
                        </div>
                      </div>
                    </div>
                  </div>
                  <p c="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[normal] min-w-px not-italic relative text-[#969696] text-[14px]" data-node-id="I856:2587;6784:16231;2404:9181">
                    The_Wand_S01E09.mp4
                  </p>
                </div>
                <div c="content-stretch flex gap-[10px] items-center relative shrink-0 w-[337px]" data-node-id="I856:2587;6784:16232" data-name="media">
                  <div c="content-stretch flex items-center justify-center relative shrink-0 size-[32px]" data-node-id="I856:2587;6784:16232;2404:9180" data-name="Icon">
                    <div c="content-stretch flex flex-[1_0_0] h-full items-center min-w-px relative" data-node-id="I856:2587;6784:16232;2404:9180;2404:9199">
                      <div c="content-stretch flex flex-[1_0_0] flex-col h-full items-start min-w-px p-[10px] relative rounded-[2px]" data-node-id="I856:2587;6784:16232;2404:9180;2404:9202">
                        <div aria-hidden c="absolute inset-0 pointer-events-none rounded-[2px]">
                          <div c="absolute bg-[#303030] inset-0 rounded-[2px]" />
                          <img alt="" c="absolute max-w-none object-cover rounded-[2px] size-full" src={imgFrame30} />
                          <img alt="" c="absolute max-w-none object-cover rounded-[2px] size-full" src={imgFrame35} />
                        </div>
                      </div>
                    </div>
                  </div>
                  <p c="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[normal] min-w-px not-italic relative text-[#969696] text-[14px]" data-node-id="I856:2587;6784:16232;2404:9181">
                    The_Wand_S01E10.mp4
                  </p>
                </div>
                <div c="content-stretch flex gap-[10px] items-center relative shrink-0 w-[337px]" data-node-id="I856:2587;6784:16233" data-name="media">
                  <div c="content-stretch flex items-center justify-center relative shrink-0 size-[32px]" data-node-id="I856:2587;6784:16233;2404:9180" data-name="Icon">
                    <div c="content-stretch flex flex-[1_0_0] h-full items-center min-w-px relative" data-node-id="I856:2587;6784:16233;2404:9180;2404:9199">
                      <div c="content-stretch flex flex-[1_0_0] flex-col h-full items-start min-w-px p-[10px] relative rounded-[2px]" data-node-id="I856:2587;6784:16233;2404:9180;2404:9202">
                        <div aria-hidden c="absolute inset-0 pointer-events-none rounded-[2px]">
                          <div c="absolute bg-[#303030] inset-0 rounded-[2px]" />
                          <img alt="" c="absolute max-w-none object-cover rounded-[2px] size-full" src={imgFrame30} />
                          <img alt="" c="absolute max-w-none object-cover rounded-[2px] size-full" src={imgFrame36} />
                        </div>
                      </div>
                    </div>
                  </div>
                  <p c="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[normal] min-w-px not-italic relative text-[#969696] text-[14px]" data-node-id="I856:2587;6784:16233;2404:9181">
                    The_Wand_S01E11.mp4
                  </p>
                </div>
                <div c="content-stretch flex gap-[10px] items-center relative shrink-0 w-[337px]" data-node-id="I856:2587;6784:16234" data-name="media">
                  <div c="content-stretch flex items-center justify-center relative shrink-0 size-[32px]" data-node-id="I856:2587;6784:16234;2404:9180" data-name="Icon">
                    <div c="content-stretch flex flex-[1_0_0] h-full items-center min-w-px relative" data-node-id="I856:2587;6784:16234;2404:9180;2404:9199">
                      <div c="content-stretch flex flex-[1_0_0] flex-col h-full items-start min-w-px p-[10px] relative rounded-[2px]" data-node-id="I856:2587;6784:16234;2404:9180;2404:9202">
                        <div aria-hidden c="absolute inset-0 pointer-events-none rounded-[2px]">
                          <div c="absolute bg-[#303030] inset-0 rounded-[2px]" />
                          <img alt="" c="absolute max-w-none object-cover rounded-[2px] size-full" src={imgFrame30} />
                          <img alt="" c="absolute max-w-none object-cover rounded-[2px] size-full" src={imgFrame37} />
                        </div>
                      </div>
                    </div>
                  </div>
                  <p c="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[normal] min-w-px not-italic relative text-[#969696] text-[14px]" data-node-id="I856:2587;6784:16234;2404:9181">
                    The_Wand_S01E12.mp4
                  </p>
                </div>
                <div c="content-stretch flex gap-[10px] items-center relative shrink-0 w-[337px]" data-node-id="I856:2587;6784:16235" data-name="media">
                  <div c="content-stretch flex items-center justify-center relative shrink-0 size-[32px]" data-node-id="I856:2587;6784:16235;2404:9180" data-name="Icon">
                    <div c="content-stretch flex flex-[1_0_0] h-full items-center min-w-px relative" data-node-id="I856:2587;6784:16235;2404:9180;2404:9199">
                      <div c="content-stretch flex flex-[1_0_0] flex-col h-full items-start min-w-px p-[10px] relative rounded-[2px]" data-node-id="I856:2587;6784:16235;2404:9180;2404:9202">
                        <div aria-hidden c="absolute inset-0 pointer-events-none rounded-[2px]">
                          <div c="absolute bg-[#303030] inset-0 rounded-[2px]" />
                          <img alt="" c="absolute max-w-none object-cover rounded-[2px] size-full" src={imgFrame30} />
                          <img alt="" c="absolute max-w-none object-cover rounded-[2px] size-full" src={imgFrame38} />
                        </div>
                      </div>
                    </div>
                  </div>
                  <p c="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[normal] min-w-px not-italic relative text-[#969696] text-[14px]" data-node-id="I856:2587;6784:16235;2404:9181">
                    The_Wand_S01E13mp4
                  </p>
                </div>
                <div c="content-stretch flex gap-[10px] items-center relative shrink-0 w-[337px]" data-node-id="I856:2587;6784:16236" data-name="media">
                  <div c="content-stretch flex items-center justify-center relative shrink-0 size-[32px]" data-node-id="I856:2587;6784:16236;2404:9180" data-name="Icon">
                    <div c="content-stretch flex flex-[1_0_0] h-full items-center min-w-px relative" data-node-id="I856:2587;6784:16236;2404:9180;2404:9199">
                      <div c="content-stretch flex flex-[1_0_0] flex-col h-full items-start min-w-px p-[10px] relative rounded-[2px]" data-node-id="I856:2587;6784:16236;2404:9180;2404:9202">
                        <div aria-hidden c="absolute inset-0 pointer-events-none rounded-[2px]">
                          <div c="absolute bg-[#303030] inset-0 rounded-[2px]" />
                          <img alt="" c="absolute max-w-none object-cover rounded-[2px] size-full" src={imgFrame30} />
                          <img alt="" c="absolute max-w-none object-cover rounded-[2px] size-full" src={imgFrame39} />
                        </div>
                      </div>
                    </div>
                  </div>
                  <p c="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[normal] min-w-px not-italic relative text-[#969696] text-[14px]" data-node-id="I856:2587;6784:16236;2404:9181">
                    The_Wand_S01E14.mp4
                  </p>
                </div>
                <div c="content-stretch flex gap-[10px] items-center relative shrink-0 w-[337px]" data-node-id="I856:2587;6784:16237" data-name="media">
                  <div c="content-stretch flex items-center justify-center relative shrink-0 size-[32px]" data-node-id="I856:2587;6784:16237;2404:9180" data-name="Icon">
                    <div c="content-stretch flex flex-[1_0_0] h-full items-center min-w-px relative" data-node-id="I856:2587;6784:16237;2404:9180;2404:9199">
                      <div c="content-stretch flex flex-[1_0_0] flex-col h-full items-start min-w-px p-[10px] relative rounded-[2px]" data-node-id="I856:2587;6784:16237;2404:9180;2404:9202">
                        <div aria-hidden c="absolute inset-0 pointer-events-none rounded-[2px]">
                          <div c="absolute bg-[#303030] inset-0 rounded-[2px]" />
                          <img alt="" c="absolute max-w-none object-cover rounded-[2px] size-full" src={imgFrame30} />
                          <img alt="" c="absolute max-w-none object-cover rounded-[2px] size-full" src={imgFrame40} />
                        </div>
                      </div>
                    </div>
                  </div>
                  <p c="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[normal] min-w-px not-italic relative text-[#969696] text-[14px]" data-node-id="I856:2587;6784:16237;2404:9181">
                    The_Wand_S01E15.mp4
                  </p>
                </div>
                <div c="content-stretch flex gap-[10px] items-center relative shrink-0 w-[337px]" data-node-id="I856:2587;6784:16238" data-name="media">
                  <div c="content-stretch flex items-center justify-center relative shrink-0 size-[32px]" data-node-id="I856:2587;6784:16238;2404:9234" data-name="Icon">
                    <div c="content-stretch flex flex-[1_0_0] h-full items-center min-w-px relative" data-node-id="I856:2587;6784:16238;2404:9234;2404:9212">
                      <div c="content-stretch flex flex-[1_0_0] flex-col h-full items-start justify-end min-w-px overflow-clip relative rounded-[2px]" data-node-id="I856:2587;6784:16238;2404:9234;2404:9213">
                        <div aria-hidden c="absolute inset-0 pointer-events-none rounded-[2px]">
                          <div c="absolute bg-[#303030] inset-0 rounded-[2px]" />
                          <img alt="" c="absolute max-w-none object-cover rounded-[2px] size-full" src={imgFrame30} />
                          <img alt="" c="absolute max-w-none object-cover rounded-[2px] size-full" src={imgFrame41} />
                        </div>
                        <div c="absolute bg-[#d37918] bottom-0 h-[3px] left-0 right-[4px]" data-node-id="I856:2587;6784:16238;2404:9234;2404:9214" />
                      </div>
                    </div>
                  </div>
                  <p c="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[normal] min-w-px not-italic relative text-[#6b6b6b] text-[14px]" data-node-id="I856:2587;6784:16238;2404:9152">
                    The_Wand_S01E01.mp4
                  </p>
                </div>
                <div c="content-stretch flex gap-[10px] items-center relative shrink-0 w-[337px]" data-node-id="I856:2587;6784:16239" data-name="media">
                  <div c="content-stretch flex items-center justify-center relative shrink-0 size-[32px]" data-node-id="I856:2587;6784:16239;2404:9234" data-name="Icon">
                    <div c="content-stretch flex flex-[1_0_0] h-full items-center min-w-px relative" data-node-id="I856:2587;6784:16239;2404:9234;2404:9212">
                      <div c="content-stretch flex flex-[1_0_0] flex-col h-full items-start justify-end min-w-px overflow-clip relative rounded-[2px]" data-node-id="I856:2587;6784:16239;2404:9234;2404:9213">
                        <div aria-hidden c="absolute inset-0 pointer-events-none rounded-[2px]">
                          <div c="absolute bg-[#303030] inset-0 rounded-[2px]" />
                          <img alt="" c="absolute max-w-none object-cover rounded-[2px] size-full" src={imgFrame30} />
                          <img alt="" c="absolute max-w-none object-cover rounded-[2px] size-full" src={imgFrame42} />
                        </div>
                        <div c="absolute bg-[#d37918] bottom-0 h-[3px] left-0 right-[4px]" data-node-id="I856:2587;6784:16239;2404:9234;2404:9214" />
                      </div>
                    </div>
                  </div>
                  <p c="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[normal] min-w-px not-italic relative text-[#6b6b6b] text-[14px]" data-node-id="I856:2587;6784:16239;2404:9152">
                    The_Wand_S01E02.mp4
                  </p>
                </div>
                <div c="content-stretch flex gap-[10px] items-center relative shrink-0 w-[337px]" data-node-id="I856:2587;6784:16240" data-name="media">
                  <div c="content-stretch flex items-center justify-center relative shrink-0 size-[32px]" data-node-id="I856:2587;6784:16240;2404:9234" data-name="Icon">
                    <div c="content-stretch flex flex-[1_0_0] h-full items-center min-w-px relative" data-node-id="I856:2587;6784:16240;2404:9234;2404:9212">
                      <div c="content-stretch flex flex-[1_0_0] flex-col h-full items-start justify-end min-w-px overflow-clip relative rounded-[2px]" data-node-id="I856:2587;6784:16240;2404:9234;2404:9213">
                        <div aria-hidden c="absolute inset-0 pointer-events-none rounded-[2px]">
                          <div c="absolute bg-[#303030] inset-0 rounded-[2px]" />
                          <img alt="" c="absolute max-w-none object-cover rounded-[2px] size-full" src={imgFrame30} />
                          <img alt="" c="absolute max-w-none object-cover rounded-[2px] size-full" src={imgFrame43} />
                        </div>
                        <div c="absolute bg-[#d37918] bottom-0 h-[3px] left-0 right-[4px]" data-node-id="I856:2587;6784:16240;2404:9234;2404:9214" />
                      </div>
                    </div>
                  </div>
                  <p c="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[normal] min-w-px not-italic relative text-[#6b6b6b] text-[14px]" data-node-id="I856:2587;6784:16240;2404:9152">
                    The_Wand_S01E03.mp4
                  </p>
                </div>
                <div c="content-stretch flex gap-[10px] items-center relative shrink-0 w-[337px]" data-node-id="I856:2587;6784:16241" data-name="media">
                  <div c="content-stretch flex items-center justify-center relative shrink-0 size-[32px]" data-node-id="I856:2587;6784:16241;2404:9234" data-name="Icon">
                    <div c="content-stretch flex flex-[1_0_0] h-full items-center min-w-px relative" data-node-id="I856:2587;6784:16241;2404:9234;2404:9212">
                      <div c="content-stretch flex flex-[1_0_0] flex-col h-full items-start justify-end min-w-px overflow-clip relative rounded-[2px]" data-node-id="I856:2587;6784:16241;2404:9234;2404:9213">
                        <div aria-hidden c="absolute inset-0 pointer-events-none rounded-[2px]">
                          <div c="absolute bg-[#303030] inset-0 rounded-[2px]" />
                          <img alt="" c="absolute max-w-none object-cover rounded-[2px] size-full" src={imgFrame30} />
                          <img alt="" c="absolute max-w-none object-cover rounded-[2px] size-full" src={imgFrame44} />
                        </div>
                        <div c="absolute bg-[#d37918] bottom-0 h-[3px] left-0 right-[4px]" data-node-id="I856:2587;6784:16241;2404:9234;2404:9214" />
                      </div>
                    </div>
                  </div>
                  <p c="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[normal] min-w-px not-italic relative text-[#6b6b6b] text-[14px]" data-node-id="I856:2587;6784:16241;2404:9152">
                    The_Wand_S01E04.mp4
                  </p>
                </div>
                <div c="absolute content-stretch flex gap-[10px] items-center left-[1450px] top-[16px] w-[337px]" data-node-id="I856:2587;6784:16242" data-name="media">
                  <div c="content-stretch flex items-center justify-center relative shrink-0 size-[32px]" data-node-id="I856:2587;6784:16242;2404:9180" data-name="Icon">
                    <div c="content-stretch flex flex-[1_0_0] h-full items-center min-w-px relative" data-node-id="I856:2587;6784:16242;2404:9180;2404:9199">
                      <div c="content-stretch flex flex-[1_0_0] flex-col h-full items-start min-w-px p-[10px] relative rounded-[2px]" data-node-id="I856:2587;6784:16242;2404:9180;2404:9202">
                        <div aria-hidden c="absolute inset-0 pointer-events-none rounded-[2px]">
                          <div c="absolute bg-[#303030] inset-0 rounded-[2px]" />
                          <img alt="" c="absolute max-w-none object-cover rounded-[2px] size-full" src={imgFrame30} />
                          <img alt="" c="absolute max-w-none object-cover rounded-[2px] size-full" src={imgFrame31} />
                        </div>
                      </div>
                    </div>
                  </div>
                  <p c="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[normal] min-w-px not-italic relative text-[#969696] text-[14px]" data-node-id="I856:2587;6784:16242;2404:9181">
                    The_Wand_S01E06.mp4
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}