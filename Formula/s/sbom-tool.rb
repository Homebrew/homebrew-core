class SbomTool < Formula
  desc "Scalable and enterprise ready tool to create SBOMs for any variety of artifacts"
  homepage "https://github.com/microsoft/sbom-tool"
  url "https://github.com/microsoft/sbom-tool/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "2cd65af77543e54be380de1ca94c681c3b880293183874368ddf4cb2957d5bfd"
  license "MIT"
  head "https://github.com/microsoft/sbom-tool.git", branch: "main"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "095f0ba6f783ca5b17418c5b4ff29a97544edf60ae8e3247cae613b2eca33c95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "095f0ba6f783ca5b17418c5b4ff29a97544edf60ae8e3247cae613b2eca33c95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "095f0ba6f783ca5b17418c5b4ff29a97544edf60ae8e3247cae613b2eca33c95"
    sha256 cellar: :any_skip_relocation, ventura:        "0f709758d7c799b43a6cbc4aefd5b900e3a5bc6934652b48a56cc719475624e5"
    sha256 cellar: :any_skip_relocation, monterey:       "0f709758d7c799b43a6cbc4aefd5b900e3a5bc6934652b48a56cc719475624e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f709758d7c799b43a6cbc4aefd5b900e3a5bc6934652b48a56cc719475624e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f6243dae54e2ec558261da8070d6c5be6ce9b3d636f97897cb1920401791f46"
  end

  depends_on "dotnet" => :build

  uses_from_macos "icu4c" => :test
  uses_from_macos "zlib"

  def install
    bin.mkdir

    dotnet_version = Formula["dotnet"].version.to_s
    inreplace "./global.json", "7.0.400", dotnet_version

    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "true"

    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --output #{buildpath}
      --runtime #{os}-#{arch}
      --self-contained=true
      -p:OFFICIAL_BUILD=true
      -p:MinVerVersionOverride=#{version}
      -p:PublishSingleFile=true
      -p:IncludeNativeLibrariesForSelfExtract=true
      -p:IncludeAllContentForSelfExtract=true
      -p:DebugType=None
      -p:DebugSymbols=false
    ]

    system "dotnet", "publish", "src/Microsoft.Sbom.Tool/Microsoft.Sbom.Tool.csproj", *args
    bin.install "Microsoft.Sbom.Tool" => "sbom-tool"
  end

  test do
    args = %W[
      -b #{testpath}
      -bc #{testpath}
      -pn TestProject
      -pv 1.2.3
      -ps Homebrew
      -nsb http://formulae.brew.sh
    ]

    system bin/"sbom-tool", "generate", *args

    json = JSON.parse((testpath/"_manifest/spdx_2.2/manifest.spdx.json").read)
    assert_equal json["name"], "TestProject 1.2.3"
  end
end
