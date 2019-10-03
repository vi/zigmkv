// This file is codegenerated. Run `./database.py --help` for info.
const mkv = @import("../mkv.zig");
const IdInfo = mkv.id.IdInfo;
const Id = mkv.id.Id;

pub const database = [_]IdInfo {

    IdInfo { .id=0x1A45DFA3, .typ=.master  , .name="EBML"                        ,.importance=.important },
    IdInfo { .id=0x4286    , .typ=.uinteger, .name="EBMLVersion"                 ,.importance=.default   },
    IdInfo { .id=0x42F7    , .typ=.uinteger, .name="EBMLReadVersion"             ,.importance=.important },
    IdInfo { .id=0x42F2    , .typ=.string  , .name="EBMLMaxIDLength"             ,.importance=.default   },
    IdInfo { .id=0x42F3    , .typ=.uinteger, .name="EBMLMaxSizeLength"           ,.importance=.default   },
    IdInfo { .id=0x4282    , .typ=.string  , .name="DocType"                     ,.importance=.important },
    IdInfo { .id=0x4287    , .typ=.uinteger, .name="DocTypeVersion"              ,.importance=.default   },
    IdInfo { .id=0x4285    , .typ=.uinteger, .name="DocTypeReadVersion"          ,.importance=.important },
    IdInfo { .id=0x4281    , .typ=.master  , .name="DocTypeExtension"            ,.importance=.default   },
    IdInfo { .id=0x4283    , .typ=.string  , .name="DocTypeExtensionName"        ,.importance=.default   },
    IdInfo { .id=0x4284    , .typ=.uinteger, .name="DocTypeExtensionVersion"     ,.importance=.default   },
    IdInfo { .id=0xEC      , .typ=.binary  , .name="Void"                        ,.importance=.default   },
    IdInfo { .id=0xBF      , .typ=.binary  , .name="CRC32"                       ,.importance=.default   },
    IdInfo { .id=0x18538067, .typ=.master  , .name="Segment"                     ,.importance=.important },
    IdInfo { .id=0x114D9B74, .typ=.master  , .name="SeekHead"                    ,.importance=.default   },
    IdInfo { .id=0x4DBB    , .typ=.master  , .name="Seek"                        ,.importance=.default   },
    IdInfo { .id=0x53AB    , .typ=.binary  , .name="SeekID"                      ,.importance=.default   },
    IdInfo { .id=0x53AC    , .typ=.uinteger, .name="SeekPosition"                ,.importance=.default   },
    IdInfo { .id=0x1549A966, .typ=.master  , .name="Info"                        ,.importance=.important },
    IdInfo { .id=0x73A4    , .typ=.binary  , .name="SegmentUID"                  ,.importance=.default   },
    IdInfo { .id=0x7384    , .typ=.utf8    , .name="SegmentFilename"             ,.importance=.default   },
    IdInfo { .id=0x3CB923  , .typ=.binary  , .name="PrevUID"                     ,.importance=.default   },
    IdInfo { .id=0x3C83AB  , .typ=.utf8    , .name="PrevFilename"                ,.importance=.default   },
    IdInfo { .id=0x3EB923  , .typ=.binary  , .name="NextUID"                     ,.importance=.default   },
    IdInfo { .id=0x3E83BB  , .typ=.utf8    , .name="NextFilename"                ,.importance=.default   },
    IdInfo { .id=0x4444    , .typ=.binary  , .name="SegmentFamily"               ,.importance=.default   },
    IdInfo { .id=0x6924    , .typ=.master  , .name="ChapterTranslate"            ,.importance=.default   },
    IdInfo { .id=0x69FC    , .typ=.uinteger, .name="ChapterTranslateEditionUID"  ,.importance=.default   },
    IdInfo { .id=0x69BF    , .typ=.uinteger, .name="ChapterTranslateCodec"       ,.importance=.default   },
    IdInfo { .id=0x69A5    , .typ=.binary  , .name="ChapterTranslateID"          ,.importance=.default   },
    IdInfo { .id=0x2AD7B1  , .typ=.uinteger, .name="TimestampScale"              ,.importance=.important },
    IdInfo { .id=0x4489    , .typ=.float   , .name="Duration"                    ,.importance=.default   },
    IdInfo { .id=0x4461    , .typ=.date    , .name="DateUTC"                     ,.importance=.default   },
    IdInfo { .id=0x7BA9    , .typ=.utf8    , .name="Title"                       ,.importance=.default   },
    IdInfo { .id=0x4D80    , .typ=.utf8    , .name="MuxingApp"                   ,.importance=.default   },
    IdInfo { .id=0x5741    , .typ=.utf8    , .name="WritingApp"                  ,.importance=.default   },
    IdInfo { .id=0x1F43B675, .typ=.master  , .name="Cluster"                     ,.importance=.hot       },
    IdInfo { .id=0xE7      , .typ=.uinteger, .name="Timestamp"                   ,.importance=.hot       },
    IdInfo { .id=0x5854    , .typ=.master  , .name="SilentTracks"                ,.importance=.default   },
    IdInfo { .id=0x58D7    , .typ=.uinteger, .name="SilentTrackNumber"           ,.importance=.default   },
    IdInfo { .id=0xA7      , .typ=.uinteger, .name="Position"                    ,.importance=.default   },
    IdInfo { .id=0xAB      , .typ=.uinteger, .name="PrevSize"                    ,.importance=.default   },
    IdInfo { .id=0xA3      , .typ=.binary  , .name="SimpleBlock"                 ,.importance=.hot       },
    IdInfo { .id=0xA0      , .typ=.master  , .name="BlockGroup"                  ,.importance=.important },
    IdInfo { .id=0xA1      , .typ=.binary  , .name="Block"                       ,.importance=.important },
    IdInfo { .id=0xA2      , .typ=.binary  , .name="BlockVirtual"                ,.importance=.default   },
    IdInfo { .id=0x75A1    , .typ=.master  , .name="BlockAdditions"              ,.importance=.default   },
    IdInfo { .id=0xA6      , .typ=.master  , .name="BlockMore"                   ,.importance=.default   },
    IdInfo { .id=0xEE      , .typ=.uinteger, .name="BlockAddID"                  ,.importance=.default   },
    IdInfo { .id=0xA5      , .typ=.binary  , .name="BlockAdditional"             ,.importance=.default   },
    IdInfo { .id=0x9B      , .typ=.uinteger, .name="BlockDuration"               ,.importance=.important },
    IdInfo { .id=0xFA      , .typ=.uinteger, .name="ReferencePriority"           ,.importance=.default   },
    IdInfo { .id=0xFB      , .typ=.integer , .name="ReferenceBlock"              ,.importance=.default   },
    IdInfo { .id=0xFD      , .typ=.integer , .name="ReferenceVirtual"            ,.importance=.default   },
    IdInfo { .id=0xA4      , .typ=.binary  , .name="CodecState"                  ,.importance=.default   },
    IdInfo { .id=0x75A2    , .typ=.integer , .name="DiscardPadding"              ,.importance=.default   },
    IdInfo { .id=0x8E      , .typ=.master  , .name="Slices"                      ,.importance=.default   },
    IdInfo { .id=0xE8      , .typ=.master  , .name="TimeSlice"                   ,.importance=.default   },
    IdInfo { .id=0xCC      , .typ=.uinteger, .name="LaceNumber"                  ,.importance=.default   },
    IdInfo { .id=0xCD      , .typ=.uinteger, .name="FrameNumber"                 ,.importance=.default   },
    IdInfo { .id=0xCB      , .typ=.uinteger, .name="BlockAdditionID"             ,.importance=.default   },
    IdInfo { .id=0xCE      , .typ=.uinteger, .name="Delay"                       ,.importance=.default   },
    IdInfo { .id=0xCF      , .typ=.uinteger, .name="SliceDuration"               ,.importance=.default   },
    IdInfo { .id=0xC8      , .typ=.master  , .name="ReferenceFrame"              ,.importance=.default   },
    IdInfo { .id=0xC9      , .typ=.uinteger, .name="ReferenceOffset"             ,.importance=.default   },
    IdInfo { .id=0xCA      , .typ=.uinteger, .name="ReferenceTimestamp"          ,.importance=.default   },
    IdInfo { .id=0xAF      , .typ=.binary  , .name="EncryptedBlock"              ,.importance=.default   },
    IdInfo { .id=0x1654AE6B, .typ=.master  , .name="Tracks"                      ,.importance=.important },
    IdInfo { .id=0xAE      , .typ=.master  , .name="TrackEntry"                  ,.importance=.important },
    IdInfo { .id=0xD7      , .typ=.uinteger, .name="TrackNumber"                 ,.importance=.important },
    IdInfo { .id=0x73C5    , .typ=.uinteger, .name="TrackUID"                    ,.importance=.default   },
    IdInfo { .id=0x83      , .typ=.uinteger, .name="TrackType"                   ,.importance=.important },
    IdInfo { .id=0xB9      , .typ=.uinteger, .name="FlagEnabled"                 ,.importance=.default   },
    IdInfo { .id=0x88      , .typ=.uinteger, .name="FlagDefault"                 ,.importance=.default   },
    IdInfo { .id=0x55AA    , .typ=.uinteger, .name="FlagForced"                  ,.importance=.default   },
    IdInfo { .id=0x9C      , .typ=.uinteger, .name="FlagLacing"                  ,.importance=.default   },
    IdInfo { .id=0x6DE7    , .typ=.uinteger, .name="MinCache"                    ,.importance=.default   },
    IdInfo { .id=0x6DF8    , .typ=.uinteger, .name="MaxCache"                    ,.importance=.default   },
    IdInfo { .id=0x23E383  , .typ=.uinteger, .name="DefaultDuration"             ,.importance=.default   },
    IdInfo { .id=0x234E7A  , .typ=.uinteger, .name="DefaultDecodedFieldDuration" ,.importance=.default   },
    IdInfo { .id=0x23314F  , .typ=.float   , .name="TrackTimestampScale"         ,.importance=.default   },
    IdInfo { .id=0x537F    , .typ=.integer , .name="TrackOffset"                 ,.importance=.default   },
    IdInfo { .id=0x55EE    , .typ=.uinteger, .name="MaxBlockAdditionID"          ,.importance=.default   },
    IdInfo { .id=0x536E    , .typ=.utf8    , .name="Name"                        ,.importance=.default   },
    IdInfo { .id=0x22B59C  , .typ=.string  , .name="Language"                    ,.importance=.default   },
    IdInfo { .id=0x22B59D  , .typ=.string  , .name="LanguageIETF"                ,.importance=.default   },
    IdInfo { .id=0x86      , .typ=.string  , .name="CodecID"                     ,.importance=.important },
    IdInfo { .id=0x63A2    , .typ=.binary  , .name="CodecPrivate"                ,.importance=.important },
    IdInfo { .id=0x258688  , .typ=.utf8    , .name="CodecName"                   ,.importance=.default   },
    IdInfo { .id=0x7446    , .typ=.uinteger, .name="AttachmentLink"              ,.importance=.default   },
    IdInfo { .id=0x3A9697  , .typ=.utf8    , .name="CodecSettings"               ,.importance=.default   },
    IdInfo { .id=0x3B4040  , .typ=.string  , .name="CodecInfoURL"                ,.importance=.default   },
    IdInfo { .id=0x26B240  , .typ=.string  , .name="CodecDownloadURL"            ,.importance=.default   },
    IdInfo { .id=0xAA      , .typ=.uinteger, .name="CodecDecodeAll"              ,.importance=.default   },
    IdInfo { .id=0x6FAB    , .typ=.uinteger, .name="TrackOverlay"                ,.importance=.default   },
    IdInfo { .id=0x56AA    , .typ=.uinteger, .name="CodecDelay"                  ,.importance=.default   },
    IdInfo { .id=0x56BB    , .typ=.uinteger, .name="SeekPreRoll"                 ,.importance=.default   },
    IdInfo { .id=0x6624    , .typ=.master  , .name="TrackTranslate"              ,.importance=.default   },
    IdInfo { .id=0x66FC    , .typ=.uinteger, .name="TrackTranslateEditionUID"    ,.importance=.default   },
    IdInfo { .id=0x66BF    , .typ=.uinteger, .name="TrackTranslateCodec"         ,.importance=.default   },
    IdInfo { .id=0x66A5    , .typ=.binary  , .name="TrackTranslateTrackID"       ,.importance=.default   },
    IdInfo { .id=0xE0      , .typ=.master  , .name="Video"                       ,.importance=.important },
    IdInfo { .id=0x9A      , .typ=.uinteger, .name="FlagInterlaced"              ,.importance=.default   },
    IdInfo { .id=0x9D      , .typ=.uinteger, .name="FieldOrder"                  ,.importance=.default   },
    IdInfo { .id=0x53B8    , .typ=.uinteger, .name="StereoMode"                  ,.importance=.default   },
    IdInfo { .id=0x53C0    , .typ=.uinteger, .name="AlphaMode"                   ,.importance=.default   },
    IdInfo { .id=0x53B9    , .typ=.uinteger, .name="OldStereoMode"               ,.importance=.default   },
    IdInfo { .id=0xB0      , .typ=.uinteger, .name="PixelWidth"                  ,.importance=.important },
    IdInfo { .id=0xBA      , .typ=.uinteger, .name="PixelHeight"                 ,.importance=.important },
    IdInfo { .id=0x54AA    , .typ=.uinteger, .name="PixelCropBottom"             ,.importance=.default   },
    IdInfo { .id=0x54BB    , .typ=.uinteger, .name="PixelCropTop"                ,.importance=.default   },
    IdInfo { .id=0x54CC    , .typ=.uinteger, .name="PixelCropLeft"               ,.importance=.default   },
    IdInfo { .id=0x54DD    , .typ=.uinteger, .name="PixelCropRight"              ,.importance=.default   },
    IdInfo { .id=0x54B0    , .typ=.uinteger, .name="DisplayWidth"                ,.importance=.default   },
    IdInfo { .id=0x54BA    , .typ=.uinteger, .name="DisplayHeight"               ,.importance=.default   },
    IdInfo { .id=0x54B2    , .typ=.uinteger, .name="DisplayUnit"                 ,.importance=.default   },
    IdInfo { .id=0x54B3    , .typ=.uinteger, .name="AspectRatioType"             ,.importance=.default   },
    IdInfo { .id=0x2EB524  , .typ=.binary  , .name="ColourSpace"                 ,.importance=.default   },
    IdInfo { .id=0x2FB523  , .typ=.float   , .name="GammaValue"                  ,.importance=.default   },
    IdInfo { .id=0x2383E3  , .typ=.float   , .name="FrameRate"                   ,.importance=.default   },
    IdInfo { .id=0x55B0    , .typ=.master  , .name="Colour"                      ,.importance=.default   },
    IdInfo { .id=0x55B1    , .typ=.uinteger, .name="MatrixCoefficients"          ,.importance=.default   },
    IdInfo { .id=0x55B2    , .typ=.uinteger, .name="BitsPerChannel"              ,.importance=.default   },
    IdInfo { .id=0x55B3    , .typ=.uinteger, .name="ChromaSubsamplingHorz"       ,.importance=.default   },
    IdInfo { .id=0x55B4    , .typ=.uinteger, .name="ChromaSubsamplingVert"       ,.importance=.default   },
    IdInfo { .id=0x55B5    , .typ=.uinteger, .name="CbSubsamplingHorz"           ,.importance=.default   },
    IdInfo { .id=0x55B6    , .typ=.uinteger, .name="CbSubsamplingVert"           ,.importance=.default   },
    IdInfo { .id=0x55B7    , .typ=.uinteger, .name="ChromaSitingHorz"            ,.importance=.default   },
    IdInfo { .id=0x55B8    , .typ=.uinteger, .name="ChromaSitingVert"            ,.importance=.default   },
    IdInfo { .id=0x55B9    , .typ=.uinteger, .name="Range"                       ,.importance=.default   },
    IdInfo { .id=0x55BA    , .typ=.uinteger, .name="TransferCharacteristics"     ,.importance=.default   },
    IdInfo { .id=0x55BB    , .typ=.uinteger, .name="Primaries"                   ,.importance=.default   },
    IdInfo { .id=0x55BC    , .typ=.uinteger, .name="MaxCLL"                      ,.importance=.default   },
    IdInfo { .id=0x55BD    , .typ=.uinteger, .name="MaxFALL"                     ,.importance=.default   },
    IdInfo { .id=0x55D0    , .typ=.master  , .name="MasteringMetadata"           ,.importance=.default   },
    IdInfo { .id=0x55D1    , .typ=.float   , .name="PrimaryRChromaticityX"       ,.importance=.default   },
    IdInfo { .id=0x55D2    , .typ=.float   , .name="PrimaryRChromaticityY"       ,.importance=.default   },
    IdInfo { .id=0x55D3    , .typ=.float   , .name="PrimaryGChromaticityX"       ,.importance=.default   },
    IdInfo { .id=0x55D4    , .typ=.float   , .name="PrimaryGChromaticityY"       ,.importance=.default   },
    IdInfo { .id=0x55D5    , .typ=.float   , .name="PrimaryBChromaticityX"       ,.importance=.default   },
    IdInfo { .id=0x55D6    , .typ=.float   , .name="PrimaryBChromaticityY"       ,.importance=.default   },
    IdInfo { .id=0x55D7    , .typ=.float   , .name="WhitePointChromaticityX"     ,.importance=.default   },
    IdInfo { .id=0x55D8    , .typ=.float   , .name="WhitePointChromaticityY"     ,.importance=.default   },
    IdInfo { .id=0x55D9    , .typ=.float   , .name="LuminanceMax"                ,.importance=.default   },
    IdInfo { .id=0x55DA    , .typ=.float   , .name="LuminanceMin"                ,.importance=.default   },
    IdInfo { .id=0x7670    , .typ=.master  , .name="Projection"                  ,.importance=.default   },
    IdInfo { .id=0x7671    , .typ=.uinteger, .name="ProjectionType"              ,.importance=.default   },
    IdInfo { .id=0x7672    , .typ=.binary  , .name="ProjectionPrivate"           ,.importance=.default   },
    IdInfo { .id=0x7673    , .typ=.float   , .name="ProjectionPoseYaw"           ,.importance=.default   },
    IdInfo { .id=0x7674    , .typ=.float   , .name="ProjectionPosePitch"         ,.importance=.default   },
    IdInfo { .id=0x7675    , .typ=.float   , .name="ProjectionPoseRoll"          ,.importance=.default   },
    IdInfo { .id=0xE1      , .typ=.master  , .name="Audio"                       ,.importance=.important },
    IdInfo { .id=0xB5      , .typ=.float   , .name="SamplingFrequency"           ,.importance=.important },
    IdInfo { .id=0x78B5    , .typ=.float   , .name="OutputSamplingFrequency"     ,.importance=.default   },
    IdInfo { .id=0x9F      , .typ=.uinteger, .name="Channels"                    ,.importance=.important },
    IdInfo { .id=0x7D7B    , .typ=.binary  , .name="ChannelPositions"            ,.importance=.default   },
    IdInfo { .id=0x6264    , .typ=.uinteger, .name="BitDepth"                    ,.importance=.default   },
    IdInfo { .id=0xE2      , .typ=.master  , .name="TrackOperation"              ,.importance=.default   },
    IdInfo { .id=0xE3      , .typ=.master  , .name="TrackCombinePlanes"          ,.importance=.default   },
    IdInfo { .id=0xE4      , .typ=.master  , .name="TrackPlane"                  ,.importance=.default   },
    IdInfo { .id=0xE5      , .typ=.uinteger, .name="TrackPlaneUID"               ,.importance=.default   },
    IdInfo { .id=0xE6      , .typ=.uinteger, .name="TrackPlaneType"              ,.importance=.default   },
    IdInfo { .id=0xE9      , .typ=.master  , .name="TrackJoinBlocks"             ,.importance=.default   },
    IdInfo { .id=0xED      , .typ=.uinteger, .name="TrackJoinUID"                ,.importance=.default   },
    IdInfo { .id=0xC0      , .typ=.uinteger, .name="TrickTrackUID"               ,.importance=.default   },
    IdInfo { .id=0xC1      , .typ=.binary  , .name="TrickTrackSegmentUID"        ,.importance=.default   },
    IdInfo { .id=0xC6      , .typ=.uinteger, .name="TrickTrackFlag"              ,.importance=.default   },
    IdInfo { .id=0xC7      , .typ=.uinteger, .name="TrickMasterTrackUID"         ,.importance=.default   },
    IdInfo { .id=0xC4      , .typ=.binary  , .name="TrickMasterTrackSegmentUID"  ,.importance=.default   },
    IdInfo { .id=0x6D80    , .typ=.master  , .name="ContentEncodings"            ,.importance=.default   },
    IdInfo { .id=0x6240    , .typ=.master  , .name="ContentEncoding"             ,.importance=.default   },
    IdInfo { .id=0x5031    , .typ=.uinteger, .name="ContentEncodingOrder"        ,.importance=.default   },
    IdInfo { .id=0x5032    , .typ=.uinteger, .name="ContentEncodingScope"        ,.importance=.default   },
    IdInfo { .id=0x5033    , .typ=.uinteger, .name="ContentEncodingType"         ,.importance=.default   },
    IdInfo { .id=0x5034    , .typ=.master  , .name="ContentCompression"          ,.importance=.important },
    IdInfo { .id=0x4254    , .typ=.uinteger, .name="ContentCompAlgo"             ,.importance=.default   },
    IdInfo { .id=0x4255    , .typ=.binary  , .name="ContentCompSettings"         ,.importance=.default   },
    IdInfo { .id=0x5035    , .typ=.master  , .name="ContentEncryption"           ,.importance=.default   },
    IdInfo { .id=0x47E1    , .typ=.uinteger, .name="ContentEncAlgo"              ,.importance=.default   },
    IdInfo { .id=0x47E2    , .typ=.binary  , .name="ContentEncKeyID"             ,.importance=.default   },
    IdInfo { .id=0x47E7    , .typ=.master  , .name="ContentEncAESSettings"       ,.importance=.default   },
    IdInfo { .id=0x47E8    , .typ=.uinteger, .name="AESSettingsCipherMode"       ,.importance=.default   },
    IdInfo { .id=0x47E3    , .typ=.binary  , .name="ContentSignature"            ,.importance=.default   },
    IdInfo { .id=0x47E4    , .typ=.binary  , .name="ContentSigKeyID"             ,.importance=.default   },
    IdInfo { .id=0x47E5    , .typ=.uinteger, .name="ContentSigAlgo"              ,.importance=.default   },
    IdInfo { .id=0x47E6    , .typ=.uinteger, .name="ContentSigHashAlgo"          ,.importance=.default   },
    IdInfo { .id=0x1C53BB6B, .typ=.master  , .name="Cues"                        ,.importance=.default   },
    IdInfo { .id=0xBB      , .typ=.master  , .name="CuePoint"                    ,.importance=.default   },
    IdInfo { .id=0xB3      , .typ=.uinteger, .name="CueTime"                     ,.importance=.default   },
    IdInfo { .id=0xB7      , .typ=.master  , .name="CueTrackPositions"           ,.importance=.default   },
    IdInfo { .id=0xF7      , .typ=.uinteger, .name="CueTrack"                    ,.importance=.default   },
    IdInfo { .id=0xF1      , .typ=.uinteger, .name="CueClusterPosition"          ,.importance=.default   },
    IdInfo { .id=0xF0      , .typ=.uinteger, .name="CueRelativePosition"         ,.importance=.default   },
    IdInfo { .id=0xB2      , .typ=.uinteger, .name="CueDuration"                 ,.importance=.default   },
    IdInfo { .id=0x5378    , .typ=.uinteger, .name="CueBlockNumber"              ,.importance=.default   },
    IdInfo { .id=0xEA      , .typ=.uinteger, .name="CueCodecState"               ,.importance=.default   },
    IdInfo { .id=0xDB      , .typ=.master  , .name="CueReference"                ,.importance=.default   },
    IdInfo { .id=0x96      , .typ=.uinteger, .name="CueRefTime"                  ,.importance=.default   },
    IdInfo { .id=0x97      , .typ=.uinteger, .name="CueRefCluster"               ,.importance=.default   },
    IdInfo { .id=0x535F    , .typ=.uinteger, .name="CueRefNumber"                ,.importance=.default   },
    IdInfo { .id=0xEB      , .typ=.uinteger, .name="CueRefCodecState"            ,.importance=.default   },
    IdInfo { .id=0x1941A469, .typ=.master  , .name="Attachments"                 ,.importance=.default   },
    IdInfo { .id=0x61A7    , .typ=.master  , .name="AttachedFile"                ,.importance=.default   },
    IdInfo { .id=0x467E    , .typ=.utf8    , .name="FileDescription"             ,.importance=.default   },
    IdInfo { .id=0x466E    , .typ=.utf8    , .name="FileName"                    ,.importance=.default   },
    IdInfo { .id=0x4660    , .typ=.string  , .name="FileMimeType"                ,.importance=.default   },
    IdInfo { .id=0x465C    , .typ=.binary  , .name="FileData"                    ,.importance=.default   },
    IdInfo { .id=0x46AE    , .typ=.uinteger, .name="FileUID"                     ,.importance=.default   },
    IdInfo { .id=0x4675    , .typ=.binary  , .name="FileReferral"                ,.importance=.default   },
    IdInfo { .id=0x4661    , .typ=.uinteger, .name="FileUsedStartTime"           ,.importance=.default   },
    IdInfo { .id=0x4662    , .typ=.uinteger, .name="FileUsedEndTime"             ,.importance=.default   },
    IdInfo { .id=0x1043A770, .typ=.master  , .name="Chapters"                    ,.importance=.default   },
    IdInfo { .id=0x45B9    , .typ=.master  , .name="EditionEntry"                ,.importance=.default   },
    IdInfo { .id=0x45BC    , .typ=.uinteger, .name="EditionUID"                  ,.importance=.default   },
    IdInfo { .id=0x45BD    , .typ=.uinteger, .name="EditionFlagHidden"           ,.importance=.default   },
    IdInfo { .id=0x45DB    , .typ=.uinteger, .name="EditionFlagDefault"          ,.importance=.default   },
    IdInfo { .id=0x45DD    , .typ=.uinteger, .name="EditionFlagOrdered"          ,.importance=.default   },
    IdInfo { .id=0xB6      , .typ=.master  , .name="ChapterAtom"                 ,.importance=.default   },
    IdInfo { .id=0x73C4    , .typ=.uinteger, .name="ChapterUID"                  ,.importance=.default   },
    IdInfo { .id=0x5654    , .typ=.utf8    , .name="ChapterStringUID"            ,.importance=.default   },
    IdInfo { .id=0x91      , .typ=.uinteger, .name="ChapterTimeStart"            ,.importance=.default   },
    IdInfo { .id=0x92      , .typ=.uinteger, .name="ChapterTimeEnd"              ,.importance=.default   },
    IdInfo { .id=0x98      , .typ=.uinteger, .name="ChapterFlagHidden"           ,.importance=.default   },
    IdInfo { .id=0x4598    , .typ=.uinteger, .name="ChapterFlagEnabled"          ,.importance=.default   },
    IdInfo { .id=0x6E67    , .typ=.binary  , .name="ChapterSegmentUID"           ,.importance=.default   },
    IdInfo { .id=0x6EBC    , .typ=.uinteger, .name="ChapterSegmentEditionUID"    ,.importance=.default   },
    IdInfo { .id=0x63C3    , .typ=.uinteger, .name="ChapterPhysicalEquiv"        ,.importance=.default   },
    IdInfo { .id=0x8F      , .typ=.master  , .name="ChapterTrack"                ,.importance=.default   },
    IdInfo { .id=0x89      , .typ=.uinteger, .name="ChapterTrackUID"             ,.importance=.default   },
    IdInfo { .id=0x80      , .typ=.master  , .name="ChapterDisplay"              ,.importance=.default   },
    IdInfo { .id=0x85      , .typ=.utf8    , .name="ChapString"                  ,.importance=.default   },
    IdInfo { .id=0x437C    , .typ=.string  , .name="ChapLanguage"                ,.importance=.default   },
    IdInfo { .id=0x437D    , .typ=.string  , .name="ChapLanguageIETF"            ,.importance=.default   },
    IdInfo { .id=0x437E    , .typ=.string  , .name="ChapCountry"                 ,.importance=.default   },
    IdInfo { .id=0x6944    , .typ=.master  , .name="ChapProcess"                 ,.importance=.default   },
    IdInfo { .id=0x6955    , .typ=.uinteger, .name="ChapProcessCodecID"          ,.importance=.default   },
    IdInfo { .id=0x450D    , .typ=.binary  , .name="ChapProcessPrivate"          ,.importance=.default   },
    IdInfo { .id=0x6911    , .typ=.master  , .name="ChapProcessCommand"          ,.importance=.default   },
    IdInfo { .id=0x6922    , .typ=.uinteger, .name="ChapProcessTime"             ,.importance=.default   },
    IdInfo { .id=0x6933    , .typ=.binary  , .name="ChapProcessData"             ,.importance=.default   },
    IdInfo { .id=0x1254C367, .typ=.master  , .name="Tags"                        ,.importance=.default   },
    IdInfo { .id=0x7373    , .typ=.master  , .name="Tag"                         ,.importance=.default   },
    IdInfo { .id=0x63C0    , .typ=.master  , .name="Targets"                     ,.importance=.default   },
    IdInfo { .id=0x68CA    , .typ=.uinteger, .name="TargetTypeValue"             ,.importance=.default   },
    IdInfo { .id=0x63CA    , .typ=.string  , .name="TargetType"                  ,.importance=.default   },
    IdInfo { .id=0x63C5    , .typ=.uinteger, .name="TagTrackUID"                 ,.importance=.default   },
    IdInfo { .id=0x63C9    , .typ=.uinteger, .name="TagEditionUID"               ,.importance=.default   },
    IdInfo { .id=0x63C4    , .typ=.uinteger, .name="TagChapterUID"               ,.importance=.default   },
    IdInfo { .id=0x63C6    , .typ=.uinteger, .name="TagAttachmentUID"            ,.importance=.default   },
    IdInfo { .id=0x67C8    , .typ=.master  , .name="SimpleTag"                   ,.importance=.default   },
    IdInfo { .id=0x45A3    , .typ=.utf8    , .name="TagName"                     ,.importance=.default   },
    IdInfo { .id=0x447A    , .typ=.string  , .name="TagLanguage"                 ,.importance=.default   },
    IdInfo { .id=0x447B    , .typ=.string  , .name="TagLanguageIETF"             ,.importance=.default   },
    IdInfo { .id=0x4484    , .typ=.uinteger, .name="TagDefault"                  ,.importance=.default   },
    IdInfo { .id=0x4487    , .typ=.utf8    , .name="TagString"                   ,.importance=.default   },
    IdInfo { .id=0x4485    , .typ=.binary  , .name="TagBinary"                   ,.importance=.default   },

};

pub const ID_EBML                           = Id.wrap(0x1A45DFA3);
pub const ID_EBMLVersion                    = Id.wrap(0x4286    );
pub const ID_EBMLReadVersion                = Id.wrap(0x42F7    );
pub const ID_EBMLMaxIDLength                = Id.wrap(0x42F2    );
pub const ID_EBMLMaxSizeLength              = Id.wrap(0x42F3    );
pub const ID_DocType                        = Id.wrap(0x4282    );
pub const ID_DocTypeVersion                 = Id.wrap(0x4287    );
pub const ID_DocTypeReadVersion             = Id.wrap(0x4285    );
pub const ID_DocTypeExtension               = Id.wrap(0x4281    );
pub const ID_DocTypeExtensionName           = Id.wrap(0x4283    );
pub const ID_DocTypeExtensionVersion        = Id.wrap(0x4284    );
pub const ID_Void                           = Id.wrap(0xEC      );
pub const ID_CRC32                          = Id.wrap(0xBF      );
pub const ID_Segment                        = Id.wrap(0x18538067);
pub const ID_SeekHead                       = Id.wrap(0x114D9B74);
pub const ID_Seek                           = Id.wrap(0x4DBB    );
pub const ID_SeekID                         = Id.wrap(0x53AB    );
pub const ID_SeekPosition                   = Id.wrap(0x53AC    );
pub const ID_Info                           = Id.wrap(0x1549A966);
pub const ID_SegmentUID                     = Id.wrap(0x73A4    );
pub const ID_SegmentFilename                = Id.wrap(0x7384    );
pub const ID_PrevUID                        = Id.wrap(0x3CB923  );
pub const ID_PrevFilename                   = Id.wrap(0x3C83AB  );
pub const ID_NextUID                        = Id.wrap(0x3EB923  );
pub const ID_NextFilename                   = Id.wrap(0x3E83BB  );
pub const ID_SegmentFamily                  = Id.wrap(0x4444    );
pub const ID_ChapterTranslate               = Id.wrap(0x6924    );
pub const ID_ChapterTranslateEditionUID     = Id.wrap(0x69FC    );
pub const ID_ChapterTranslateCodec          = Id.wrap(0x69BF    );
pub const ID_ChapterTranslateID             = Id.wrap(0x69A5    );
pub const ID_TimestampScale                 = Id.wrap(0x2AD7B1  );
pub const ID_Duration                       = Id.wrap(0x4489    );
pub const ID_DateUTC                        = Id.wrap(0x4461    );
pub const ID_Title                          = Id.wrap(0x7BA9    );
pub const ID_MuxingApp                      = Id.wrap(0x4D80    );
pub const ID_WritingApp                     = Id.wrap(0x5741    );
pub const ID_Cluster                        = Id.wrap(0x1F43B675);
pub const ID_Timestamp                      = Id.wrap(0xE7      );
pub const ID_SilentTracks                   = Id.wrap(0x5854    );
pub const ID_SilentTrackNumber              = Id.wrap(0x58D7    );
pub const ID_Position                       = Id.wrap(0xA7      );
pub const ID_PrevSize                       = Id.wrap(0xAB      );
pub const ID_SimpleBlock                    = Id.wrap(0xA3      );
pub const ID_BlockGroup                     = Id.wrap(0xA0      );
pub const ID_Block                          = Id.wrap(0xA1      );
pub const ID_BlockVirtual                   = Id.wrap(0xA2      );
pub const ID_BlockAdditions                 = Id.wrap(0x75A1    );
pub const ID_BlockMore                      = Id.wrap(0xA6      );
pub const ID_BlockAddID                     = Id.wrap(0xEE      );
pub const ID_BlockAdditional                = Id.wrap(0xA5      );
pub const ID_BlockDuration                  = Id.wrap(0x9B      );
pub const ID_ReferencePriority              = Id.wrap(0xFA      );
pub const ID_ReferenceBlock                 = Id.wrap(0xFB      );
pub const ID_ReferenceVirtual               = Id.wrap(0xFD      );
pub const ID_CodecState                     = Id.wrap(0xA4      );
pub const ID_DiscardPadding                 = Id.wrap(0x75A2    );
pub const ID_Slices                         = Id.wrap(0x8E      );
pub const ID_TimeSlice                      = Id.wrap(0xE8      );
pub const ID_LaceNumber                     = Id.wrap(0xCC      );
pub const ID_FrameNumber                    = Id.wrap(0xCD      );
pub const ID_BlockAdditionID                = Id.wrap(0xCB      );
pub const ID_Delay                          = Id.wrap(0xCE      );
pub const ID_SliceDuration                  = Id.wrap(0xCF      );
pub const ID_ReferenceFrame                 = Id.wrap(0xC8      );
pub const ID_ReferenceOffset                = Id.wrap(0xC9      );
pub const ID_ReferenceTimestamp             = Id.wrap(0xCA      );
pub const ID_EncryptedBlock                 = Id.wrap(0xAF      );
pub const ID_Tracks                         = Id.wrap(0x1654AE6B);
pub const ID_TrackEntry                     = Id.wrap(0xAE      );
pub const ID_TrackNumber                    = Id.wrap(0xD7      );
pub const ID_TrackUID                       = Id.wrap(0x73C5    );
pub const ID_TrackType                      = Id.wrap(0x83      );
pub const ID_FlagEnabled                    = Id.wrap(0xB9      );
pub const ID_FlagDefault                    = Id.wrap(0x88      );
pub const ID_FlagForced                     = Id.wrap(0x55AA    );
pub const ID_FlagLacing                     = Id.wrap(0x9C      );
pub const ID_MinCache                       = Id.wrap(0x6DE7    );
pub const ID_MaxCache                       = Id.wrap(0x6DF8    );
pub const ID_DefaultDuration                = Id.wrap(0x23E383  );
pub const ID_DefaultDecodedFieldDuration    = Id.wrap(0x234E7A  );
pub const ID_TrackTimestampScale            = Id.wrap(0x23314F  );
pub const ID_TrackOffset                    = Id.wrap(0x537F    );
pub const ID_MaxBlockAdditionID             = Id.wrap(0x55EE    );
pub const ID_Name                           = Id.wrap(0x536E    );
pub const ID_Language                       = Id.wrap(0x22B59C  );
pub const ID_LanguageIETF                   = Id.wrap(0x22B59D  );
pub const ID_CodecID                        = Id.wrap(0x86      );
pub const ID_CodecPrivate                   = Id.wrap(0x63A2    );
pub const ID_CodecName                      = Id.wrap(0x258688  );
pub const ID_AttachmentLink                 = Id.wrap(0x7446    );
pub const ID_CodecSettings                  = Id.wrap(0x3A9697  );
pub const ID_CodecInfoURL                   = Id.wrap(0x3B4040  );
pub const ID_CodecDownloadURL               = Id.wrap(0x26B240  );
pub const ID_CodecDecodeAll                 = Id.wrap(0xAA      );
pub const ID_TrackOverlay                   = Id.wrap(0x6FAB    );
pub const ID_CodecDelay                     = Id.wrap(0x56AA    );
pub const ID_SeekPreRoll                    = Id.wrap(0x56BB    );
pub const ID_TrackTranslate                 = Id.wrap(0x6624    );
pub const ID_TrackTranslateEditionUID       = Id.wrap(0x66FC    );
pub const ID_TrackTranslateCodec            = Id.wrap(0x66BF    );
pub const ID_TrackTranslateTrackID          = Id.wrap(0x66A5    );
pub const ID_Video                          = Id.wrap(0xE0      );
pub const ID_FlagInterlaced                 = Id.wrap(0x9A      );
pub const ID_FieldOrder                     = Id.wrap(0x9D      );
pub const ID_StereoMode                     = Id.wrap(0x53B8    );
pub const ID_AlphaMode                      = Id.wrap(0x53C0    );
pub const ID_OldStereoMode                  = Id.wrap(0x53B9    );
pub const ID_PixelWidth                     = Id.wrap(0xB0      );
pub const ID_PixelHeight                    = Id.wrap(0xBA      );
pub const ID_PixelCropBottom                = Id.wrap(0x54AA    );
pub const ID_PixelCropTop                   = Id.wrap(0x54BB    );
pub const ID_PixelCropLeft                  = Id.wrap(0x54CC    );
pub const ID_PixelCropRight                 = Id.wrap(0x54DD    );
pub const ID_DisplayWidth                   = Id.wrap(0x54B0    );
pub const ID_DisplayHeight                  = Id.wrap(0x54BA    );
pub const ID_DisplayUnit                    = Id.wrap(0x54B2    );
pub const ID_AspectRatioType                = Id.wrap(0x54B3    );
pub const ID_ColourSpace                    = Id.wrap(0x2EB524  );
pub const ID_GammaValue                     = Id.wrap(0x2FB523  );
pub const ID_FrameRate                      = Id.wrap(0x2383E3  );
pub const ID_Colour                         = Id.wrap(0x55B0    );
pub const ID_MatrixCoefficients             = Id.wrap(0x55B1    );
pub const ID_BitsPerChannel                 = Id.wrap(0x55B2    );
pub const ID_ChromaSubsamplingHorz          = Id.wrap(0x55B3    );
pub const ID_ChromaSubsamplingVert          = Id.wrap(0x55B4    );
pub const ID_CbSubsamplingHorz              = Id.wrap(0x55B5    );
pub const ID_CbSubsamplingVert              = Id.wrap(0x55B6    );
pub const ID_ChromaSitingHorz               = Id.wrap(0x55B7    );
pub const ID_ChromaSitingVert               = Id.wrap(0x55B8    );
pub const ID_Range                          = Id.wrap(0x55B9    );
pub const ID_TransferCharacteristics        = Id.wrap(0x55BA    );
pub const ID_Primaries                      = Id.wrap(0x55BB    );
pub const ID_MaxCLL                         = Id.wrap(0x55BC    );
pub const ID_MaxFALL                        = Id.wrap(0x55BD    );
pub const ID_MasteringMetadata              = Id.wrap(0x55D0    );
pub const ID_PrimaryRChromaticityX          = Id.wrap(0x55D1    );
pub const ID_PrimaryRChromaticityY          = Id.wrap(0x55D2    );
pub const ID_PrimaryGChromaticityX          = Id.wrap(0x55D3    );
pub const ID_PrimaryGChromaticityY          = Id.wrap(0x55D4    );
pub const ID_PrimaryBChromaticityX          = Id.wrap(0x55D5    );
pub const ID_PrimaryBChromaticityY          = Id.wrap(0x55D6    );
pub const ID_WhitePointChromaticityX        = Id.wrap(0x55D7    );
pub const ID_WhitePointChromaticityY        = Id.wrap(0x55D8    );
pub const ID_LuminanceMax                   = Id.wrap(0x55D9    );
pub const ID_LuminanceMin                   = Id.wrap(0x55DA    );
pub const ID_Projection                     = Id.wrap(0x7670    );
pub const ID_ProjectionType                 = Id.wrap(0x7671    );
pub const ID_ProjectionPrivate              = Id.wrap(0x7672    );
pub const ID_ProjectionPoseYaw              = Id.wrap(0x7673    );
pub const ID_ProjectionPosePitch            = Id.wrap(0x7674    );
pub const ID_ProjectionPoseRoll             = Id.wrap(0x7675    );
pub const ID_Audio                          = Id.wrap(0xE1      );
pub const ID_SamplingFrequency              = Id.wrap(0xB5      );
pub const ID_OutputSamplingFrequency        = Id.wrap(0x78B5    );
pub const ID_Channels                       = Id.wrap(0x9F      );
pub const ID_ChannelPositions               = Id.wrap(0x7D7B    );
pub const ID_BitDepth                       = Id.wrap(0x6264    );
pub const ID_TrackOperation                 = Id.wrap(0xE2      );
pub const ID_TrackCombinePlanes             = Id.wrap(0xE3      );
pub const ID_TrackPlane                     = Id.wrap(0xE4      );
pub const ID_TrackPlaneUID                  = Id.wrap(0xE5      );
pub const ID_TrackPlaneType                 = Id.wrap(0xE6      );
pub const ID_TrackJoinBlocks                = Id.wrap(0xE9      );
pub const ID_TrackJoinUID                   = Id.wrap(0xED      );
pub const ID_TrickTrackUID                  = Id.wrap(0xC0      );
pub const ID_TrickTrackSegmentUID           = Id.wrap(0xC1      );
pub const ID_TrickTrackFlag                 = Id.wrap(0xC6      );
pub const ID_TrickMasterTrackUID            = Id.wrap(0xC7      );
pub const ID_TrickMasterTrackSegmentUID     = Id.wrap(0xC4      );
pub const ID_ContentEncodings               = Id.wrap(0x6D80    );
pub const ID_ContentEncoding                = Id.wrap(0x6240    );
pub const ID_ContentEncodingOrder           = Id.wrap(0x5031    );
pub const ID_ContentEncodingScope           = Id.wrap(0x5032    );
pub const ID_ContentEncodingType            = Id.wrap(0x5033    );
pub const ID_ContentCompression             = Id.wrap(0x5034    );
pub const ID_ContentCompAlgo                = Id.wrap(0x4254    );
pub const ID_ContentCompSettings            = Id.wrap(0x4255    );
pub const ID_ContentEncryption              = Id.wrap(0x5035    );
pub const ID_ContentEncAlgo                 = Id.wrap(0x47E1    );
pub const ID_ContentEncKeyID                = Id.wrap(0x47E2    );
pub const ID_ContentEncAESSettings          = Id.wrap(0x47E7    );
pub const ID_AESSettingsCipherMode          = Id.wrap(0x47E8    );
pub const ID_ContentSignature               = Id.wrap(0x47E3    );
pub const ID_ContentSigKeyID                = Id.wrap(0x47E4    );
pub const ID_ContentSigAlgo                 = Id.wrap(0x47E5    );
pub const ID_ContentSigHashAlgo             = Id.wrap(0x47E6    );
pub const ID_Cues                           = Id.wrap(0x1C53BB6B);
pub const ID_CuePoint                       = Id.wrap(0xBB      );
pub const ID_CueTime                        = Id.wrap(0xB3      );
pub const ID_CueTrackPositions              = Id.wrap(0xB7      );
pub const ID_CueTrack                       = Id.wrap(0xF7      );
pub const ID_CueClusterPosition             = Id.wrap(0xF1      );
pub const ID_CueRelativePosition            = Id.wrap(0xF0      );
pub const ID_CueDuration                    = Id.wrap(0xB2      );
pub const ID_CueBlockNumber                 = Id.wrap(0x5378    );
pub const ID_CueCodecState                  = Id.wrap(0xEA      );
pub const ID_CueReference                   = Id.wrap(0xDB      );
pub const ID_CueRefTime                     = Id.wrap(0x96      );
pub const ID_CueRefCluster                  = Id.wrap(0x97      );
pub const ID_CueRefNumber                   = Id.wrap(0x535F    );
pub const ID_CueRefCodecState               = Id.wrap(0xEB      );
pub const ID_Attachments                    = Id.wrap(0x1941A469);
pub const ID_AttachedFile                   = Id.wrap(0x61A7    );
pub const ID_FileDescription                = Id.wrap(0x467E    );
pub const ID_FileName                       = Id.wrap(0x466E    );
pub const ID_FileMimeType                   = Id.wrap(0x4660    );
pub const ID_FileData                       = Id.wrap(0x465C    );
pub const ID_FileUID                        = Id.wrap(0x46AE    );
pub const ID_FileReferral                   = Id.wrap(0x4675    );
pub const ID_FileUsedStartTime              = Id.wrap(0x4661    );
pub const ID_FileUsedEndTime                = Id.wrap(0x4662    );
pub const ID_Chapters                       = Id.wrap(0x1043A770);
pub const ID_EditionEntry                   = Id.wrap(0x45B9    );
pub const ID_EditionUID                     = Id.wrap(0x45BC    );
pub const ID_EditionFlagHidden              = Id.wrap(0x45BD    );
pub const ID_EditionFlagDefault             = Id.wrap(0x45DB    );
pub const ID_EditionFlagOrdered             = Id.wrap(0x45DD    );
pub const ID_ChapterAtom                    = Id.wrap(0xB6      );
pub const ID_ChapterUID                     = Id.wrap(0x73C4    );
pub const ID_ChapterStringUID               = Id.wrap(0x5654    );
pub const ID_ChapterTimeStart               = Id.wrap(0x91      );
pub const ID_ChapterTimeEnd                 = Id.wrap(0x92      );
pub const ID_ChapterFlagHidden              = Id.wrap(0x98      );
pub const ID_ChapterFlagEnabled             = Id.wrap(0x4598    );
pub const ID_ChapterSegmentUID              = Id.wrap(0x6E67    );
pub const ID_ChapterSegmentEditionUID       = Id.wrap(0x6EBC    );
pub const ID_ChapterPhysicalEquiv           = Id.wrap(0x63C3    );
pub const ID_ChapterTrack                   = Id.wrap(0x8F      );
pub const ID_ChapterTrackUID                = Id.wrap(0x89      );
pub const ID_ChapterDisplay                 = Id.wrap(0x80      );
pub const ID_ChapString                     = Id.wrap(0x85      );
pub const ID_ChapLanguage                   = Id.wrap(0x437C    );
pub const ID_ChapLanguageIETF               = Id.wrap(0x437D    );
pub const ID_ChapCountry                    = Id.wrap(0x437E    );
pub const ID_ChapProcess                    = Id.wrap(0x6944    );
pub const ID_ChapProcessCodecID             = Id.wrap(0x6955    );
pub const ID_ChapProcessPrivate             = Id.wrap(0x450D    );
pub const ID_ChapProcessCommand             = Id.wrap(0x6911    );
pub const ID_ChapProcessTime                = Id.wrap(0x6922    );
pub const ID_ChapProcessData                = Id.wrap(0x6933    );
pub const ID_Tags                           = Id.wrap(0x1254C367);
pub const ID_Tag                            = Id.wrap(0x7373    );
pub const ID_Targets                        = Id.wrap(0x63C0    );
pub const ID_TargetTypeValue                = Id.wrap(0x68CA    );
pub const ID_TargetType                     = Id.wrap(0x63CA    );
pub const ID_TagTrackUID                    = Id.wrap(0x63C5    );
pub const ID_TagEditionUID                  = Id.wrap(0x63C9    );
pub const ID_TagChapterUID                  = Id.wrap(0x63C4    );
pub const ID_TagAttachmentUID               = Id.wrap(0x63C6    );
pub const ID_SimpleTag                      = Id.wrap(0x67C8    );
pub const ID_TagName                        = Id.wrap(0x45A3    );
pub const ID_TagLanguage                    = Id.wrap(0x447A    );
pub const ID_TagLanguageIETF                = Id.wrap(0x447B    );
pub const ID_TagDefault                     = Id.wrap(0x4484    );
pub const ID_TagString                      = Id.wrap(0x4487    );
pub const ID_TagBinary                      = Id.wrap(0x4485    );
