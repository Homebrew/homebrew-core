class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/cpisciotta/xcbeautify"
  url "https://github.com/cpisciotta/xcbeautify/archive/refs/tags/2.15.0.tar.gz"
  sha256 "952fe800799273778cd4e6a90b9622d968a62aedc2bc2d74fe48cc512e5f25cb"
  license "MIT"
  head "https://github.com/cpisciotta/xcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d23e840464bbf6edc84bed41f1fb60bb059210859a5ab853733fee93da829bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dabdaf1bc6342827485281230b6f519b08842aa83908a61987710a29f09d33f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "239a42eac4867f6f18b3071209cfa96932b084aaea2b88b7e309fabf5a355602"
    sha256 cellar: :any_skip_relocation, sonoma:        "e665c219099d8b08ee099082433886161e39eccf529628bb26a14cc70731dd20"
    sha256 cellar: :any_skip_relocation, ventura:       "3a85897debcffb6fe14c3773b70d76c901151b674a95a76b38ff918e1cad60d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55be4016fdb96e789ca168e4064f2bc71211a4ddf4590c88b0053d311faec385"
  end

  # needs Swift tools version 5.9.0
  depends_on xcode: ["15.0", :build]

  uses_from_macos "swift" => :build
  uses_from_macos "libxml2"

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "--configuration", "release"
    bin.install ".build/release/xcbeautify"
  end

  test do
    log = "CompileStoryboard /Users/admin/MyApp/MyApp/Main.storyboard (in target: MyApp)"
    assert_match "[MyApp] Compiling Main.storyboard",
      pipe_output("#{bin}/xcbeautify --disable-colored-output", log).chomp
    assert_match version.to_s,
      shell_output("#{bin}/xcbeautify --version").chomp
  end
end
