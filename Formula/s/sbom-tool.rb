class SbomTool < Formula
  desc "Scalable and enterprise ready tool to create SBOMs for any variety of artifacts"
  homepage "https://github.com/microsoft/sbom-tool"
  url "https://github.com/microsoft/sbom-tool/archive/refs/tags/v4.1.3.tar.gz"
  sha256 "61f64331d17b993b8881d1ca6627efabbc98150a55aa60207b7a63410880536a"
  license "MIT"
  head "https://github.com/microsoft/sbom-tool.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c085f49baa49436a269813eb7ad56ea879928fb5c576aaecfda66d71d2b9b90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fff7012a666d8fd826c4e2f694271c0424b9a42320cc98dc2facaaffb6246e55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29b3eacb58a469d024486efa5d5fc86ce727cf8b7512faaf66357fab3bdb6f4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cfec54a08d07b209776172824827abc224e0787dda54e6940e0e278567f01af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cb55721ec430a16f646bbe897f4bc0a036c8b1ee8b2ff3a10702500fd7d3c48"
  end

  depends_on "dotnet@8"

  uses_from_macos "zlib"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "true"

    dotnet = Formula["dotnet@8"]
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --no-self-contained
      --output #{libexec}
      --use-current-runtime
      -p:OFFICIAL_BUILD=true
      -p:MinVerVersionOverride=#{version}
      -p:PublishSingleFile=true
      -p:IncludeNativeLibrariesForSelfExtract=true
      -p:IncludeAllContentForSelfExtract=true
      -p:DebugType=None
      -p:DebugSymbols=false
    ]

    system "dotnet", "publish", "src/Microsoft.Sbom.Tool/Microsoft.Sbom.Tool.csproj", *args
    (bin/"sbom-tool").write_env_script libexec/"Microsoft.Sbom.Tool", DOTNET_ROOT: dotnet.opt_libexec
  end

  test do
    args = %W[
      -b #{testpath}
      -bc #{testpath}
      -pn TestProject
      -pv 1.2.3
      -ps Homebrew
      -nsb https://formulae.brew.sh
    ]

    system bin/"sbom-tool", "generate", *args

    json = JSON.parse((testpath/"_manifest/spdx_2.2/manifest.spdx.json").read)
    assert_equal json["name"], "TestProject 1.2.3"
  end
end
