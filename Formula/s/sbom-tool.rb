class SbomTool < Formula
  desc "Scalable and enterprise ready tool to create SBOMs for any variety of artifacts"
  homepage "https://github.com/microsoft/sbom-tool"
  url "https://github.com/microsoft/sbom-tool/archive/refs/tags/v2.2.4.tar.gz"
  sha256 "7f05d7d456c9c6cf5bea442c4a2b73d8c956d6f8e0c0d949fb7fa2230007532b"
  license "MIT"
  head "https://github.com/microsoft/sbom-tool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26f8938e5458ff6eea4a9ece59faa15ddad3d90a95b2558f29a4665865c680c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f828629e383fb4df9e0d62f36a577ce08d9253560d253c260d67a82435de2c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a14e772173a9e9de39d7ff993111a02d6d081556fc12fc43f7310ce1ce8a2b62"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e76331fe972b37484507ffbb7e574bcfc7999534cf75d6264ef91590520becd"
    sha256 cellar: :any_skip_relocation, ventura:        "7e9d584fd6cf49f536e47d8335fdc4040aa360aea40643120bd0463363eb360a"
    sha256 cellar: :any_skip_relocation, monterey:       "f5fcbf030c10ba6c446d042758309e466e8f71d9039b8fc3e3fb5872b5ced75b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59bf7165dafd2f9f3b5114c590ec5672708b2173563216015f41d1c076fe5c8c"
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
