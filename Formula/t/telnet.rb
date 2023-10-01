class Telnet < Formula
  desc "User interface to the TELNET protocol"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/remote_cmds/archive/refs/tags/remote_cmds-69.tar.gz"
  sha256 "ce917122a88f8bee98686476abf83f1d442e387637a021eabe02f0fe88e02986"
  license all_of: ["BSD-4-Clause-UC", "APSL-1.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8489d1062562a4d311517ff650b6a2a03f84f7935e2e71aee2fe83cf96567f17"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59e9f6c98b4a22c314d741d0b54ae3cfb083b9b7069c8a11e7f34ff32a4e5744"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c047ca7e8df187e638154fcc246a35555325b2e7078afa40808753446aa56009"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12076e9de5b1fba596e5f56151a4f6a50307c070ca0ae0d387fc4cd923476d87"
    sha256 cellar: :any_skip_relocation, sonoma:         "98a3f9b8d34896313b6858648150c44d976d8112760a86ec0f80b71f908154ac"
    sha256 cellar: :any_skip_relocation, ventura:        "b51c080ed44f4c8512eb4a46cf175e2c503b935a86623ee85bdb5679cdb26625"
    sha256 cellar: :any_skip_relocation, monterey:       "bcba419b9e7fc87a4a53f36d5ef7c71aa2a5f1de9f5372d05ae631da137ed444"
    sha256 cellar: :any_skip_relocation, big_sur:        "79720536bf6b812009dec6eb258d80881ffc31c05359051088e11ee4a5a78539"
  end

  depends_on xcode: :build
  depends_on :macos

  conflicts_with "inetutils", because: "both install 'telnet' binaries"

  resource "libtelnet" do
    url "https://github.com/apple-oss-distributions/libtelnet/archive/refs/tags/libtelnet-13.tar.gz"
    sha256 "4ffc494a069257477c3a02769a395da8f72f5c26218a02b9ea73fa2a63216cee"
  end

  def install
    resource("libtelnet").stage do
      ENV["SDKROOT"] = MacOS.sdk_path
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

      xcodebuild "OBJROOT=build/Intermediates",
                 "SYMROOT=build/Products",
                 "DSTROOT=build/Archive",
                 "-IDEBuildLocationStyle=Custom",
                 "-IDECustomDerivedDataLocation=#{buildpath}",
                 "-arch", Hardware::CPU.arch

      libtelnet_dst = buildpath/"libtelnet"
      libtelnet_dst.install "build/Products/Release/libtelnet.a"
      libtelnet_dst.install "build/Products/Release/usr/local/include/libtelnet/"
    end

    xcodebuild "OBJROOT=build/Intermediates",
               "SYMROOT=build/Products",
               "DSTROOT=build/Archive",
               "OTHER_CFLAGS=${inherited} #{ENV.cflags} -I#{buildpath}/libtelnet",
               "OTHER_LDFLAGS=${inherited} #{ENV.ldflags} -L#{buildpath}/libtelnet",
               "-IDEBuildLocationStyle=Custom",
               "-IDECustomDerivedDataLocation=#{buildpath}",
               "-sdk", "macosx",
               "-arch", Hardware::CPU.arch,
               "-target", "telnet"

    bin.install "build/Products/Release/telnet"
    man1.install "telnet/telnet.1"
  end

  test do
    output = shell_output("#{bin}/telnet india.colorado.edu 13", 1)
    assert_match "Connected to india.colorado.edu.", output
  end
end
