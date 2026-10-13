/* Juxtopposed VLC redesign, CC BY 4.0. Figma reference only.
 * File kJ3O3At8xC5cqxEwD2LD1n, node 2238:9432, retrieved 2026-10-13.
 * The asset URLs below are temporary; the implementation uses the existing QML components and icon font.
 */
const assetPathPrefix = "https://www.figma.com/api/mcp/asset/590c9cd7-77f6-4353-9eae-aa1ac42778ad";
const imgFrame1 = `${assetPathPrefix}/1b0f7.svg`;
const imgFrame17 = `${assetPathPrefix}/617e8.svg`;
const imgFrame18 = `${assetPathPrefix}/1f761.svg`;
const imgFrame2 = `${assetPathPrefix}/d74b3.svg`;
const imgFrame = `${assetPathPrefix}/764c9.svg`;
const imgRectangle6 = `${assetPathPrefix}/07eaa.svg`;
const imgRectangle7 = `${assetPathPrefix}/f1da4.svg`;
const imgRectangle8 = `${assetPathPrefix}/2be1c.svg`;
const imgFrame3 = `${assetPathPrefix}/4ecaf.svg`;
const imgFrame4 = `${assetPathPrefix}/bf521.svg`;
const imgVolume = `${assetPathPrefix}/6aa6b.svg`;
const imgFrame5 = `${assetPathPrefix}/432a4.svg`;
const imgFrame6 = `${assetPathPrefix}/3ffd5.svg`;
const imgFrame7 = `${assetPathPrefix}/e80b5.svg`;
const imgFrame8 = `${assetPathPrefix}/0eda2.svg`;
const imgFrame9 = `${assetPathPrefix}/85ff4.svg`;
const imgFrame10 = `${assetPathPrefix}/48d70.svg`;
const imgVector = `${assetPathPrefix}/a95d1.svg`;
const imgFrame11 = `${assetPathPrefix}/ac8b1.svg`;
const imgVector1 = `${assetPathPrefix}/9a7e4.svg`;
const imgFrame12 = `${assetPathPrefix}/94cee.svg`;
const imgFrame13 = `${assetPathPrefix}/6d2f8.svg`;
const imgVector2 = `${assetPathPrefix}/ee2e1.svg`;
const imgVector3 = `${assetPathPrefix}/9ddc4.svg`;
const imgVector59 = `${assetPathPrefix}/8ba8e.svg`;
const imgVector60 = `${assetPathPrefix}/1ab84.svg`;

type IconProps = {
  className?: string;
  direction?: "default";
  eq?: "default";
  name?: "settings" | "next" | "previous" | "check";
  state?: "default" | "active";
  twoTone?: boolean;
  value?: "default";
};

function Icon({ className, direction = "default", eq = "default", name = "settings", state = "default", twoTone = false, value = "default" }: IconProps) {
  const isCheckAndActiveAndDefaultAndFalse = name === "check" && state === "active" && eq === "default" && !twoTone;
  const isNextAndDefaultAndDefaultAndFalse = name === "next" && state === "default" && eq === "default" && !twoTone;
  const isPreviousAndDefaultAndDefaultAndFalse = name === "previous" && state === "default" && eq === "default" && !twoTone;
  return (
    <div className={className || `content-stretch flex items-center justify-center relative ${state === "default" && eq === "default" && !twoTone && ["next", "previous"].includes(name) ? "size-[24px]" : ""}`} id={isCheckAndActiveAndDefaultAndFalse ? "node-494_2394" : isPreviousAndDefaultAndDefaultAndFalse ? "node-45_18" : isNextAndDefaultAndDefaultAndFalse ? "node-45_12" : "node-42_355"}>
      <div className="relative shrink-0 size-[24px]" id={isCheckAndActiveAndDefaultAndFalse ? "node-494_2395" : isPreviousAndDefaultAndDefaultAndFalse ? "node-177_83" : isNextAndDefaultAndDefaultAndFalse ? "node-177_79" : "node-44_413"}>
        <img alt="" className="absolute block inset-0 max-w-none size-full" src={isCheckAndActiveAndDefaultAndFalse ? imgFrame2 : isPreviousAndDefaultAndDefaultAndFalse ? imgFrame18 : isNextAndDefaultAndDefaultAndFalse ? imgFrame17 : imgFrame1} />
      </div>
    </div>
  );
}

type AudioVisualizerProps = {
  className?: string;
  state?: "default";
};

function AudioVisualizer({ className, state = "default" }: AudioVisualizerProps) {
  return (
    <button className={className || "bg-[#090909] content-stretch cursor-pointer flex items-start justify-center p-[2px] relative rounded-[6px] w-[362px]"} data-node-id="2372:8640">
      <div className="bg-[#191919] content-stretch flex flex-[1_0_0] gap-[10px] h-[44px] items-center min-w-px px-[14px] py-[2px] relative rounded-[4px]" data-node-id="2372:8641" data-name="option">
        <p className="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[normal] min-w-px not-italic relative text-[#8f8f8f] text-[14px] text-left" data-node-id="I2372:8641;2107:5930">
          Disabled
        </p>
        <div className="content-stretch flex items-center justify-center relative shrink-0" data-node-id="I2372:8641;2107:5931" data-name="Icon">
          <div className="flex items-center justify-center relative shrink-0" data-node-id="I2372:8641;2107:5931;71:869">
            <div className="-scale-y-100 flex-none rotate-180">
              <div className="relative size-[24px]" data-name="Frame">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgFrame} />
              </div>
            </div>
          </div>
        </div>
      </div>
    </button>
  );
}

type ToggleProps = {
  className?: string;
  value?: boolean;
};

function Toggle({ className, value = true }: ToggleProps) {
  const isNotValue = !value;
  return (
    <button className={className || "bg-[#090909] block h-[32px] relative rounded-[6px] w-[68px]"} id={isNotValue ? "node-536_1336" : "node-536_1013"}>
      <div className={`-translate-y-1/2 absolute h-[26px] rounded-[3px] top-1/2 w-[33px] ${isNotValue ? "bg-[#191919] left-[32px]" : "bg-[#371f06] left-[3px]"}`} id={isNotValue ? "node-536_1337" : "node-536_1010"} />
      <div className={`-translate-y-1/2 absolute rounded-[3px] size-[26px] top-1/2 ${isNotValue ? "bg-[#404040] left-[3px]" : "bg-[#ab6314] left-[39px]"}`} id={isNotValue ? "node-536_1338" : "node-536_1011"} />
      <p className={`[word-break:break-word] absolute font-["Inter:Regular"] font-normal leading-[normal] not-italic text-[12px] text-left top-[calc(50%-7px)] whitespace-nowrap ${isNotValue ? "left-[calc(50%+2px)] text-[#6b6b6b]" : "left-[10px] text-[#d37918]"}`} id={isNotValue ? "node-536_1339" : "node-536_1012"}>
        {isNotValue ? "OFF" : "ON"}
      </p>
    </button>
  );
}

type VolumeProps = {
  className?: string;
  property1?: "50%";
};

function Volume({ className, property1 = "50%" }: VolumeProps) {
  return (
    <div className={className || "h-[28px] relative w-[88px]"} data-node-id="244:210">
      <div className="-translate-x-1/2 -translate-y-1/2 absolute h-[28px] left-[calc(50%+0.5px)] top-1/2 w-[89px]" data-node-id="244:211">
        <div className="absolute inset-[1.14%_0]">
          <img alt="" className="block max-w-none size-full" src={imgRectangle6} />
        </div>
      </div>
      <div className="-translate-x-1/2 -translate-y-1/2 absolute contents left-[calc(50%-27.5px)] top-1/2" data-node-id="244:212">
        <div className="-translate-x-1/2 -translate-y-1/2 absolute h-[25px] left-[calc(50%+0.5px)] mask-alpha mask-intersect mask-no-clip mask-no-repeat mask-position-[-1.5px_-2.5px] mask-size-[33px_30px] top-1/2 w-[86px]" data-node-id="244:214" style={{ maskImage: `url("${imgRectangle7}")` }}>
          <div className="absolute inset-[0.88%_0]">
            <img alt="" className="block max-w-none size-full" src={imgRectangle8} />
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
    <button className={className || "content-stretch flex h-[28px] items-center justify-center px-[8px] py-[2px] relative rounded-[6px] w-[76px]"} data-node-id="1905:7313">
      <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#8f8f8f] text-[15px] text-left whitespace-nowrap" data-node-id="1905:7314">
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
    <div className={className || "content-stretch flex h-[28px] items-center justify-center px-[8px] py-[2px] relative rounded-[6px] w-[76px]"} data-node-id="1904:7237">
      <p className="[word-break:break-word] font-['Inter:Regular'] font-normal h-[17px] leading-[normal] not-italic relative shrink-0 text-[#8f8f8f] text-[15px] w-[63px]" data-node-id="1904:7236">
        00:02:10
      </p>
    </div>
  );
}

type PlayProps = {
  className?: string;
  type?: "play";
};

function Play({ className, type = "play" }: PlayProps) {
  return (
    <button className={className || "bg-[#d37918] content-stretch flex items-center justify-center pl-[17px] pr-[15px] py-[2px] relative rounded-[6px] w-[54px]"} data-node-id="848:1711">
      <div className="content-stretch flex items-center justify-center relative shrink-0" data-node-id="848:1707" data-name="Icon">
        <div className="relative shrink-0 size-[24px]" data-node-id="I848:1707;44:420" data-name="Frame">
          <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgFrame3} />
        </div>
      </div>
    </button>
  );
}

type ControlsProps = {
  className?: string;
  property1?: "default" | "playback";
};

function Controls({ className, property1 = "default" }: ControlsProps) {
  const isDefault = property1 === "default";
  const isPlayback = property1 === "playback";
  return (
    <div className={className || `backdrop-blur-[25px] bg-[rgba(25,25,25,0.95)] border-[#222] border-solid border-t content-stretch flex gap-[20px] h-[54px] items-center px-[20px] py-[11px] relative w-[1920px] ${isPlayback ? "" : "overflow-clip"}`} id={isPlayback ? "node-2238_9432" : "node-491_1779"}>
      <div className="content-stretch flex gap-[8px] items-center relative shrink-0" id={isPlayback ? "node-2238_9433" : "node-3603_12301"}>
        <div className="content-stretch flex items-center justify-center px-[3px] py-[2px] relative shrink-0" id={isPlayback ? "node-2238_9434" : "node-3603_12302"}>
          {isDefault && (
            <div className="content-stretch flex items-center justify-center relative shrink-0 size-[24px]" data-node-id="3603:12303" data-name="Icon">
              <div className="relative shrink-0 size-[24px]" data-node-id="I3603:12303;177:83">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgFrame18} />
              </div>
            </div>
          )}
          {isPlayback && <Icon className="content-stretch flex items-center justify-center relative shrink-0 size-[24px]" name="previous" />}
        </div>
        {isDefault && (
          <>
            <button className="bg-[#d37918] content-stretch cursor-pointer flex items-center justify-center pl-[17px] pr-[15px] py-[2px] relative rounded-[6px] shrink-0 w-[54px]" data-node-id="3603:12304" data-name="play">
              <div className="content-stretch flex items-center justify-center relative shrink-0" data-node-id="I3603:12304;848:1707" data-name="Icon">
                <div className="relative shrink-0 size-[24px]" data-node-id="I3603:12304;848:1707;44:420" data-name="Frame">
                  <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgFrame3} />
                </div>
              </div>
            </button>
            <div className="content-stretch flex items-center justify-center px-[3px] py-[2px] relative shrink-0" data-node-id="3603:12305">
              <div className="content-stretch flex items-center justify-center relative shrink-0 size-[24px]" data-node-id="3603:12306" data-name="Icon">
                <div className="relative shrink-0 size-[24px]" data-node-id="I3603:12306;177:79">
                  <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgFrame17} />
                </div>
              </div>
            </div>
          </>
        )}
        {isPlayback && (
          <>
            <Play className="bg-[#d37918] content-stretch cursor-pointer flex items-center justify-center pl-[17px] pr-[15px] py-[2px] relative rounded-[6px] shrink-0 w-[54px]" />
            <div className="content-stretch flex items-center justify-center px-[3px] py-[2px] relative shrink-0" data-node-id="2238:9437">
              <Icon className="content-stretch flex items-center justify-center relative shrink-0 size-[24px]" name="next" />
            </div>
          </>
        )}
      </div>
      {isDefault && (
        <button className="content-stretch cursor-pointer flex flex-[1_0_0] gap-[8px] items-center justify-center min-w-px relative" data-node-id="1908:7385">
          <div className="content-stretch flex h-[28px] items-center justify-center px-[8px] py-[2px] relative rounded-[6px] shrink-0 w-[76px]" data-node-id="1908:7386" data-name="Current Time">
            <p className="[word-break:break-word] font-['Inter:Regular'] font-normal h-[17px] leading-[normal] not-italic relative shrink-0 text-[#8f8f8f] text-[15px] text-left w-[63px]" data-node-id="I1908:7386;1904:7236">
              00:02:10
            </p>
          </div>
          <div className="bg-[#090909] flex-[1_0_0] h-[28px] min-w-px relative rounded-[6px]" data-node-id="1908:7387">
            <div className="absolute bg-[#371f06] h-[24px] left-[2px] rounded-[4px] top-[2px] w-[98px]" data-node-id="1908:7388" />
            <div className="absolute bg-[#d37918] h-[24px] left-[92px] rounded-[4px] top-[2px] w-[8px]" data-node-id="1908:7389" />
          </div>
          <div className="content-stretch flex h-[28px] items-center justify-center px-[8px] py-[2px] relative rounded-[6px] shrink-0 w-[76px]" data-node-id="1908:7390" role="button" tabIndex="0" data-name="Duration">
            <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#8f8f8f] text-[15px] text-left whitespace-nowrap" data-node-id="I1908:7390;1905:7314">
              00:25:40
            </p>
          </div>
        </button>
      )}
      <div className={`content-stretch flex gap-[8px] items-center relative ${isPlayback ? "flex-[1_0_0] justify-center min-w-px" : "justify-end shrink-0"}`} id={isPlayback ? "node-2238_9440" : "node-491_1731"}>
        {isDefault && (
          <>
            <div className="content-stretch flex items-center justify-center relative shrink-0" data-node-id="491:1732" data-name="Icon">
              <div className="flex items-center justify-center relative shrink-0" data-node-id="I491:1732;182:180">
                <div className="-scale-y-100 flex-none rotate-180">
                  <div className="relative size-[24px]" data-name="Frame">
                    <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgFrame4} />
                  </div>
                </div>
              </div>
            </div>
            <div className="h-[28px] relative shrink-0 w-[88px]" data-node-id="491:1733" data-name="volume">
              <div className="absolute inset-[0_-1.14%_0_0]">
                <img alt="" className="block max-w-none size-full" src={imgVolume} />
              </div>
            </div>
          </>
        )}
        {isPlayback && (
          <>
            <CurrentTime className="content-stretch flex h-[28px] items-center justify-center px-[8px] py-[2px] relative rounded-[6px] shrink-0 w-[76px]" />
            <div className="bg-[#090909] flex-[1_0_0] h-[28px] min-w-px relative rounded-[6px]" data-node-id="2238:9442">
              <div className="absolute bg-[#371f06] h-[24px] left-[2px] rounded-[4px] top-[2px] w-[98px]" data-node-id="2238:9443" />
              <div className="absolute bg-[#d37918] h-[24px] left-[92px] rounded-[4px] top-[2px] w-[8px]" data-node-id="2238:9444" />
            </div>
            <Duration className="content-stretch cursor-pointer flex h-[28px] items-center justify-center px-[8px] py-[2px] relative rounded-[6px] shrink-0 w-[76px]" />
          </>
        )}
      </div>
      <div className={`content-stretch flex items-center relative shrink-0 ${isPlayback ? "gap-[8px] justify-end" : "cursor-pointer gap-[12px]"}`} id={isPlayback ? "node-2238_9446" : "node-491_1728"}>
        {isDefault && (
          <>
            <button className="content-stretch flex items-center justify-center p-[4px] relative rounded-[4px] shrink-0 w-[30px]" data-node-id="496:2470" data-name="Icon Wrapper">
              <div className="content-stretch flex items-center justify-center relative shrink-0" data-node-id="I496:2470;177:88" data-name="Icon">
                <div className="relative shrink-0 size-[24px]" data-node-id="I496:2470;177:88;44:408" data-name="Frame">
                  <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgFrame5} />
                </div>
              </div>
            </button>
            <button className="content-stretch flex items-center justify-center p-[4px] relative rounded-[4px] shrink-0 w-[30px]" data-node-id="491:1730" data-name="Icon Wrapper">
              <div className="content-stretch flex items-center justify-center relative shrink-0" data-node-id="I491:1730;177:88" data-name="Icon">
                <div className="relative shrink-0 size-[24px]" data-node-id="I491:1730;177:88;42:399" data-name="Frame">
                  <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgFrame6} />
                </div>
              </div>
            </button>
            <button className="content-stretch flex items-center justify-center p-[4px] relative rounded-[4px] shrink-0 w-[30px]" data-node-id="491:1729" data-name="Icon Wrapper">
              <div className="content-stretch flex items-center justify-center relative shrink-0" data-node-id="I491:1729;177:88" data-name="Icon">
                <div className="relative shrink-0 size-[24px]" data-node-id="I491:1729;177:88;2230:9223">
                  <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgFrame7} />
                </div>
              </div>
            </button>
          </>
        )}
        {isPlayback && (
          <>
            <div className="content-stretch flex items-center justify-center relative shrink-0" data-node-id="2238:9447" data-name="Icon">
              <div className="flex items-center justify-center relative shrink-0" data-node-id="I2238:9447;182:180">
                <div className="-scale-y-100 flex-none rotate-180">
                  <div className="relative size-[24px]" data-name="Frame">
                    <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgFrame4} />
                  </div>
                </div>
              </div>
            </div>
            <Volume className="h-[28px] relative shrink-0 w-[88px]" />
          </>
        )}
      </div>
      {isDefault && (
        <button className="content-stretch cursor-pointer flex items-center justify-center p-[4px] relative rounded-[4px] shrink-0 w-[30px]" data-node-id="491:1734" data-name="Icon Wrapper">
          <div className="content-stretch flex items-center justify-center relative shrink-0" data-node-id="I491:1734;177:88" data-name="Icon">
            <div className="relative shrink-0 size-[24px]" data-node-id="I491:1734;177:88;217:192" data-name="Frame">
              <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgFrame8} />
            </div>
          </div>
        </button>
      )}
      {isPlayback && (
        <>
          <div className="content-stretch cursor-pointer flex gap-[12px] items-center relative shrink-0" data-node-id="2238:9449">
            <button className="content-stretch flex items-center justify-center p-[4px] relative rounded-[4px] shrink-0 w-[30px]" data-node-id="2238:9450" data-name="Icon Wrapper">
              <div className="content-stretch flex items-center justify-center relative shrink-0" data-node-id="I2238:9450;177:88" data-name="Icon">
                <div className="relative shrink-0 size-[24px]" data-node-id="I2238:9450;177:88;44:408" data-name="Frame">
                  <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgFrame5} />
                </div>
              </div>
            </button>
            <button className="content-stretch flex items-center justify-center p-[4px] relative rounded-[4px] shrink-0 w-[30px]" data-node-id="2238:9451" data-name="Icon Wrapper">
              <div className="content-stretch flex items-center justify-center relative shrink-0" data-node-id="I2238:9451;177:88" data-name="Icon">
                <div className="relative shrink-0 size-[24px]" data-node-id="I2238:9451;177:88;42:399" data-name="Frame">
                  <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgFrame6} />
                </div>
              </div>
            </button>
            <button className="content-stretch flex items-center justify-center p-[4px] relative rounded-[4px] shrink-0 w-[30px]" data-node-id="2238:9452" data-name="Icon Wrapper">
              <div className="content-stretch flex items-center justify-center relative shrink-0" data-node-id="I2238:9452;177:88" data-name="Icon">
                <div className="relative shrink-0 size-[24px]" data-node-id="I2238:9452;177:88;2238:9233">
                  <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgFrame9} />
                </div>
              </div>
            </button>
          </div>
          <button className="content-stretch cursor-pointer flex items-center justify-center p-[4px] relative rounded-[4px] shrink-0 w-[30px]" data-node-id="2238:9453" data-name="Icon Wrapper">
            <div className="content-stretch flex items-center justify-center relative shrink-0" data-node-id="I2238:9453;177:88" data-name="Icon">
              <div className="relative shrink-0 size-[24px]" data-node-id="I2238:9453;177:88;217:192" data-name="Frame">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgFrame8} />
              </div>
            </div>
          </button>
          <div className="absolute backdrop-blur-[25px] bg-[rgba(14,14,14,0.95)] bottom-[74px] content-stretch flex flex-col gap-px h-[946px] items-start overflow-clip right-[20px] rounded-[10px] w-[400px]" data-node-id="5187:24308" data-name="Subtitles">
            <div className="bg-[#090909] content-stretch cursor-pointer flex gap-px items-center px-[6px] relative shrink-0 w-full" data-node-id="5187:24309">
              <button className="content-stretch flex flex-[1_0_0] flex-col h-[50px] items-center justify-between min-w-px pt-[14px] px-[8px] relative" data-node-id="5187:24310">
                <div className="content-stretch flex gap-[8px] items-center justify-center relative shrink-0 w-full" data-node-id="5187:24311">
                  <div className="content-stretch flex items-center justify-center relative shrink-0" data-node-id="5187:24312" data-name="Icon">
                    <div className="relative shrink-0 size-[20px]" data-node-id="I5187:24312;6073:13945" data-name="Frame">
                      <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgFrame10} />
                    </div>
                  </div>
                  <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#8f8f8f] text-[12px] text-center whitespace-nowrap" data-node-id="5187:24313">
                    Playback
                  </p>
                </div>
                <div className="h-[2px] relative shrink-0 w-full" data-node-id="5187:24314" data-name="Vector">
                  <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgVector} />
                </div>
              </button>
              <button className="content-stretch flex flex-col h-[50px] items-center justify-between pt-[14px] px-[12px] relative shrink-0 w-[85px]" data-node-id="5187:24315">
                <div className="content-stretch flex gap-[8px] items-center justify-center relative shrink-0 w-full" data-node-id="5187:24316">
                  <div className="content-stretch flex items-center justify-center relative shrink-0 size-[20px]" data-node-id="5187:24317" data-name="Icon">
                    <div className="-translate-x-1/2 -translate-y-1/2 absolute flex items-center justify-center left-1/2 size-[20px] top-1/2" data-node-id="I5187:24317;999:4811">
                      <div className="-scale-y-100 flex-none rotate-180">
                        <div className="relative size-[20px]" data-name="Frame">
                          <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgFrame11} />
                        </div>
                      </div>
                    </div>
                  </div>
                  <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#6b6b6b] text-[12px] text-center whitespace-nowrap" data-node-id="5187:24318">
                    Video
                  </p>
                </div>
                <div className="h-[2px] relative shrink-0 w-full" data-node-id="5187:24319" data-name="Vector">
                  <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgVector1} />
                </div>
              </button>
              <button className="content-stretch flex flex-col h-[50px] items-center justify-between pt-[14px] px-[12px] relative shrink-0 w-[85px]" data-node-id="5187:24320">
                <div className="content-stretch flex gap-[8px] items-center justify-center relative shrink-0 w-full" data-node-id="5187:24321">
                  <div className="content-stretch flex items-center justify-center relative shrink-0" data-node-id="5187:24322" data-name="Icon">
                    <div className="relative shrink-0 size-[20px]" data-node-id="I5187:24322;44:408" data-name="Frame">
                      <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgFrame12} />
                    </div>
                  </div>
                  <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#6b6b6b] text-[12px] text-center whitespace-nowrap" data-node-id="5187:24323">
                    Audio
                  </p>
                </div>
                <div className="h-[2px] relative shrink-0 w-full" data-node-id="5187:24324" data-name="Vector">
                  <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgVector1} />
                </div>
              </button>
              <button className="content-stretch flex flex-[1_0_0] flex-col h-[50px] items-center justify-between min-w-px pt-[14px] px-[8px] relative" data-node-id="5187:24325">
                <div className="content-stretch flex gap-[8px] items-center justify-center relative shrink-0 w-full" data-node-id="5187:24326">
                  <div className="content-stretch flex items-center justify-center relative shrink-0" data-node-id="5187:24327" data-name="Icon">
                    <div className="relative shrink-0 size-[20px]" data-node-id="I5187:24327;42:399" data-name="Frame">
                      <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgFrame13} />
                    </div>
                  </div>
                  <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#6b6b6b] text-[12px] text-center whitespace-nowrap" data-node-id="5187:24328">
                    Subtitles
                  </p>
                </div>
                <div className="h-[2px] relative shrink-0 w-full" data-node-id="5187:24329" data-name="Vector">
                  <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgVector2} />
                </div>
              </button>
            </div>
            <div className="content-stretch flex flex-[1_0_0] flex-col isolate items-start min-h-px overflow-x-clip overflow-y-auto relative w-full" data-node-id="5187:24330">
              <div className="h-0 relative shrink-0 w-full z-[8]" data-node-id="5187:24342" data-name="Vector">
                <div className="absolute inset-[-0.5px_0]">
                  <img alt="" className="block max-w-none size-full" src={imgVector3} />
                </div>
              </div>
              <div className="h-0 relative shrink-0 w-full z-[7]" data-node-id="5187:24374" data-name="Vector">
                <div className="absolute inset-[-0.5px_0]">
                  <img alt="" className="block max-w-none size-full" src={imgVector3} />
                </div>
              </div>
              <div className="content-stretch flex flex-col items-center pt-[10px] px-[20px] relative shrink-0 w-full z-[6]" data-node-id="5187:24486">
                <button className="content-stretch cursor-pointer flex items-center justify-between pl-[4px] py-[10px] relative shrink-0 w-full" data-node-id="5187:24487">
                  <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#6b6b6b] text-[14px] text-left whitespace-nowrap" data-node-id="5187:24488">
                    Show Subtitle Timeline on Seekbar
                  </p>
                  <Toggle className="bg-[#090909] h-[32px] relative rounded-[6px] shrink-0 w-[68px]" value={false} />
                </button>
              </div>
              <div className="content-stretch flex flex-col items-center px-[20px] relative shrink-0 w-full z-[5]" data-node-id="5187:24490">
                <div className="content-stretch flex items-center justify-between pl-[4px] py-[10px] relative shrink-0 w-full" data-node-id="5187:24491">
                  <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#6b6b6b] text-[14px] whitespace-nowrap" data-node-id="5187:24492">
                    Show Statistics
                  </p>
                  <Toggle className="bg-[#090909] block cursor-pointer h-[32px] relative rounded-[6px] shrink-0 w-[68px]" value={false} />
                </div>
              </div>
              <div className="content-stretch flex flex-col items-center px-[20px] relative shrink-0 w-full z-[4]" data-node-id="5187:24494">
                <div className="content-stretch flex items-center justify-between pl-[4px] py-[10px] relative shrink-0 w-full" data-node-id="5187:24495">
                  <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#6b6b6b] text-[14px] whitespace-nowrap" data-node-id="5187:24496">
                    Reverse
                  </p>
                  <Toggle className="bg-[#090909] block cursor-pointer h-[32px] relative rounded-[6px] shrink-0 w-[68px]" value={false} />
                </div>
              </div>
              <div className="content-stretch flex items-center justify-between pb-[20px] pt-[10px] px-[20px] relative shrink-0 w-full z-[3]" data-node-id="5187:24532">
                <div className="content-stretch flex items-center pl-[4px] pr-[8px] py-[10px] relative shrink-0" data-node-id="5187:24533">
                  <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#6b6b6b] text-[14px] whitespace-nowrap" data-node-id="5187:24534">
                    Sleep Timer
                  </p>
                </div>
                <div className="bg-[#090909] content-stretch flex gap-[10px] items-center justify-center p-[2px] relative rounded-[6px] shrink-0 w-[220px]" data-node-id="5187:24535" data-name="EQ">
                  <div className="bg-[#191919] flex-[1_0_0] h-[44px] min-w-px relative rounded-[4px]" data-node-id="5187:24536" />
                  <p className="[word-break:break-word] absolute font-['Inter:Regular'] font-normal leading-[normal] left-[18px] not-italic text-[#8f8f8f] text-[14px] top-[15.5px] whitespace-nowrap" data-node-id="5187:24537">
                    Off
                  </p>
                  <div className="-translate-y-1/2 absolute content-stretch flex items-center justify-center right-[14px] top-1/2" data-node-id="5187:24538" data-name="Icon">
                    <div className="flex items-center justify-center relative shrink-0" data-node-id="I5187:24538;71:869">
                      <div className="-scale-y-100 flex-none rotate-180">
                        <div className="relative size-[24px]" data-name="Frame">
                          <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgFrame} />
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div className="content-stretch flex items-center justify-between pb-[20px] px-[20px] relative shrink-0 w-full z-[2]" data-node-id="5187:24514">
                <div className="content-stretch flex items-center pl-[4px] pr-[8px] py-[10px] relative shrink-0" data-node-id="5187:24515">
                  <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#6b6b6b] text-[14px] whitespace-nowrap" data-node-id="5187:24516">
                    Audio Visualizer
                  </p>
                </div>
                <AudioVisualizer className="bg-[#090909] content-stretch cursor-pointer flex items-start justify-center p-[2px] relative rounded-[6px] shrink-0 w-[220px]" />
              </div>
              <div className="content-stretch flex flex-col gap-[10px] items-center pb-[15px] px-[20px] relative shrink-0 w-full z-[1]" data-node-id="5187:24539">
                <div className="content-stretch flex items-center justify-between pl-[4px] py-[6px] relative shrink-0 w-full" data-node-id="5187:24540">
                  <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#6b6b6b] text-[14px] w-[79px]" data-node-id="5187:24541">
                    Speed
                  </p>
                  <div className="bg-[#090909] content-stretch flex h-[32px] items-center pl-[12px] pr-[18px] py-[8px] relative rounded-[6px] shrink-0 w-[140px]" data-node-id="5187:24542">
                    <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#6b6b6b] text-[14px] whitespace-nowrap" data-node-id="5187:24543">
                      1x
                    </p>
                  </div>
                </div>
                <div className="content-stretch flex flex-col gap-[10px] items-start py-[4px] relative shrink-0 w-full" data-node-id="5187:24544" data-name="wrapper">
                  <div className="content-stretch flex flex-col items-start py-[4px] relative shrink-0 w-full" data-node-id="5187:24545" data-name="wrapper">
                    <div className="bg-[#090909] content-stretch flex flex-col gap-[10px] items-start p-[2px] relative rounded-[6px] shrink-0 w-full" data-node-id="5187:24546" data-name="range">
                      <div className="bg-[#371f06] h-[12px] relative rounded-[4px] shrink-0 w-[159px]" data-node-id="5187:24547" />
                      <div className="-translate-y-1/2 absolute content-stretch flex items-center justify-between left-[0.61%] mix-blend-screen right-[0.61%] top-1/2" data-node-id="5187:24548" data-name="degrees">
                        <div className="h-[6px] relative shrink-0 w-0" data-node-id="5187:24549">
                          <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgVector59} />
                        </div>
                        <div className="h-[6px] relative shrink-0 w-0" data-node-id="5187:24550">
                          <div className="absolute inset-[-16.67%_-1px]">
                            <img alt="" className="block max-w-none size-full" src={imgVector60} />
                          </div>
                        </div>
                        <div className="h-[6px] relative shrink-0 w-0" data-node-id="5187:24551">
                          <div className="absolute inset-[-16.67%_-1px]">
                            <img alt="" className="block max-w-none size-full" src={imgVector60} />
                          </div>
                        </div>
                        <div className="h-[6px] relative shrink-0 w-0" data-node-id="5187:24552">
                          <div className="absolute inset-[-16.67%_-1px]">
                            <img alt="" className="block max-w-none size-full" src={imgVector60} />
                          </div>
                        </div>
                        <div className="h-[6px] relative shrink-0 w-0" data-node-id="5187:24553">
                          <div className="absolute inset-[-16.67%_-1px]">
                            <img alt="" className="block max-w-none size-full" src={imgVector60} />
                          </div>
                        </div>
                        <div className="h-[6px] relative shrink-0 w-0" data-node-id="5187:24554">
                          <div className="absolute inset-[-16.67%_-1px]">
                            <img alt="" className="block max-w-none size-full" src={imgVector60} />
                          </div>
                        </div>
                        <div className="h-[6px] relative shrink-0 w-0" data-node-id="5187:24555">
                          <div className="absolute inset-[-16.67%_-1px]">
                            <img alt="" className="block max-w-none size-full" src={imgVector60} />
                          </div>
                        </div>
                        <div className="h-[6px] relative shrink-0 w-0" data-node-id="5187:24556">
                          <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgVector59} />
                        </div>
                      </div>
                      <div className="-translate-x-1/2 -translate-y-1/2 absolute bg-[#ab6314] h-[24px] left-[calc(50%-23px)] rounded-[4px] top-1/2 w-[8px]" data-node-id="5187:24557" data-name="thumb" />
                    </div>
                  </div>
                  <div className="content-stretch flex items-center justify-between relative shrink-0 w-full" data-node-id="5187:24558">
                    <div className="h-[15px] relative shrink-0 w-[18px]" data-node-id="5187:24559">
                      <p className="[word-break:break-word] absolute font-['Inter:Regular'] font-normal leading-[normal] left-[2px] not-italic text-[#6b6b6b] text-[12px] top-0 w-[26px]" data-node-id="5187:24560">
                        0.25
                      </p>
                    </div>
                    <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#6b6b6b] text-[12px] text-center w-[26px]" data-node-id="5187:24561">
                      0.5
                    </p>
                    <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#6b6b6b] text-[12px] text-center w-[26px]" data-node-id="5187:24562">
                      0.75
                    </p>
                    <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#6b6b6b] text-[12px] text-center w-[26px]" data-node-id="5187:24563">
                      1
                    </p>
                    <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#6b6b6b] text-[12px] text-center w-[26px]" data-node-id="5187:24564">
                      1.25
                    </p>
                    <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#6b6b6b] text-[12px] text-center w-[26px]" data-node-id="5187:24565">
                      1.5
                    </p>
                    <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#6b6b6b] text-[12px] text-center w-[26px]" data-node-id="5187:24566">
                      1.75
                    </p>
                    <div className="h-[15px] relative shrink-0 w-[18px]" data-node-id="5187:24567">
                      <p className="[word-break:break-word] absolute font-['Inter:Regular'] font-normal leading-[normal] not-italic right-[2px] text-[#6b6b6b] text-[12px] text-right top-0 w-[26px]" data-node-id="5187:24568">
                        2
                      </p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </>
      )}
    </div>
  );
}
