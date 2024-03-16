class SbomTool < Formula
  desc "Scalable and enterprise ready tool to create SBOMs for any variety of artifacts"
  homepage "https://github.com/microsoft/sbom-tool"
  url "https://github.com/microsoft/sbom-tool/archive/refs/tags/v2.2.4.tar.gz"
  sha256 "7f05d7d456c9c6cf5bea442c4a2b73d8c956d6f8e0c0d949fb7fa2230007532b"
  license "MIT"
  head "https://github.com/microsoft/sbom-tool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c04c6c3f382672eeffd9b10995bdbf1ca5739c8d500c03f95af59041b33fadb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31e74da4ee4928e4d990d12be2b2bc7fc30e51304504e73409bdcb2d47487d36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ff54ab7537a50cc9bb3ea1312c2321867e25379589d7ca407ab449aede975ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "b375236f623baaac85ed2b0464ac19ed69fdcc77bcc60946532eadf4043ef189"
    sha256 cellar: :any_skip_relocation, ventura:        "8e48149a6e7a1ac6e65fed986c9db548548c13f9a85327247ff7bd30de06ced6"
    sha256 cellar: :any_skip_relocation, monterey:       "c1fc2b0cbeddc236a84bbc9420a8c57ef00cb196282aa6153bb4f8fe16de87b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "102e91117f030ecc17960ffab7afc7c4fd7e82cfd2efe20876ef7536c8265cb0"
  end

  depends_on "dotnet"

  uses_from_macos "icu4c" => :test
  uses_from_macos "zlib"

  def install
    bin.mkdir

    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "true"

    dotnet = Formula["dotnet"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
      -p:OFFICIAL_BUILD=true
      -p:MinVerVersionOverride=#{version}
      -p:PublishSingleFile=true
      -p:IncludeNativeLibrariesForSelfExtract=true
      -p:IncludeAllContentForSelfExtract=true
      -p:DebugType=None
      -p:DebugSymbols=false
    ]

    system "dotnet", "publish", "src/Microsoft.Sbom.Tool/Microsoft.Sbom.Tool.csproj", *args
    (bin/"sbom-tool").write_env_script libexec/"Microsoft.Sbom.Tool",
                                       DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
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
