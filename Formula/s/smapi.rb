class Smapi < Formula
  desc "Modding API for Stardew Valley"
  homepage "https://smapi.io"
  url "https://github.com/Pathoschild/SMAPI/archive/refs/tags/4.5.1.tar.gz"
  sha256 "895894a1597a53526854b79c5c096fa2234599c6e0b75c2c3cf464d531f3f0c8"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "dotnet"
  uses_from_macos "zip" => :build

  resource "reference-assemblies" do
    url "https://github.com/StardewModders/mod-reference-assemblies/archive/0141355fecb8536715ecff22f99374b5e632cbed.tar.gz"
    sha256 "1db0e09df776e3a59f5cabf2200f47bd10ec535ad18e9fd05f06d0cecc618c43"
  end

  def install
    resource("reference-assemblies").stage(buildpath/"ref")

    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    runtime = OS.mac? ? "osx-#{arch}" : "linux-#{arch}"
    os_name = OS.mac? ? "OSX" : "Unix"

    common_args = %W[
      --configuration Release
      --runtime #{runtime}
      --no-self-contained
      -p:GamePath=#{buildpath}/ref
      -p:CopyToGameFolder=false
      -p:OS=#{os_name}
      -p:RollForward=LatestMajor
      -p:PublishTrimmed=false
      -p:PlatformTarget=#{Hardware::CPU.arm? ? "ARM64" : "x64"}
    ]

    system "dotnet", "publish", "src/SMAPI", *common_args
    system "dotnet", "publish", "src/SMAPI.Installer", *common_args

    (buildpath/"bundle/smapi-internal").mkpath
    smapi_publish = buildpath/"src/SMAPI/bin/Release/#{runtime}/publish"

    %w[StardewModdingAPI.dll StardewModdingAPI.xml steam_appid.txt].each do |file|
      (buildpath/"bundle").install smapi_publish/file if (smapi_publish/file).exist?
    end

    (buildpath/"bundle").install buildpath/"src/SMAPI.Installer/assets/unix-launcher.sh" => "StardewModdingAPI"
    (buildpath/"bundle").install buildpath/"src/SMAPI.Installer/assets/runtimeconfig.json" =>
                                                                                              "StardewModdingAPI." \
                                                                                              "runtimeconfig.json"

    internal_files = Dir["#{smapi_publish}/*.dll"] - Dir["#{smapi_publish}/StardewModdingAPI.dll"]
    (buildpath/"bundle/smapi-internal").install internal_files
    (buildpath/"bundle/smapi-internal").install smapi_publish/"i18n" if (smapi_publish/"i18n").exist?

    %w[blacklist.json config.json metadata.json].each do |file|
      next unless (smapi_publish/"SMAPI.#{file}").exist?

      (buildpath/"bundle/smapi-internal").install smapi_publish/"SMAPI.#{file}" => file
    end

    cd "bundle" do
      system "zip", "-r", buildpath/"install.dat", "."
    end

    installer_publish = buildpath/"src/SMAPI.Installer/bin/Release/#{runtime}/publish"
    libexec.install Dir["#{installer_publish}/*"]
    libexec.install buildpath/"install.dat"

    (bin/"smapi").write_env_script "dotnet", "#{libexec}/SMAPI.Installer.dll",
                                   DOTNET_ROOT: Formula["dotnet"].opt_libexec
  end

  test do
    game_path = if OS.mac?
      testpath/"Library/Application Support/Steam/steamapps/common/Stardew Valley/Contents/MacOS"
    else
      testpath/".local/share/Steam/steamapps/common/Stardew Valley"
    end
    game_path.mkpath
    (game_path/"Stardew Valley.deps.json").write "{}"
    (game_path/"StardewValley").write ""
    (game_path/"StardewValley.dll").write ""

    output = shell_output("#{bin}/smapi --install --game-path '#{game_path}' --no-prompt")
    assert_match "Extracting install files...", output
    assert_match "Failed finding your game path", output
  end
end
