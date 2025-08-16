class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/cpisciotta/xcbeautify"
  url "https://github.com/cpisciotta/xcbeautify/archive/refs/tags/2.30.1.tar.gz"
  sha256 "6cc64ef9167a02b1c097f995941e93d756e27c570006ad6f9e9c83db83ed2603"
  license "MIT"
  head "https://github.com/cpisciotta/xcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee1f233d52ac4b8541e9bc5bf43b5ee15e5246130bfc500ef248b68ea8e4ad5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f193dcd43fe565fed28381ebf6f55240d137063507ff96f59dbe3b87091a295"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e7755f538b36b686e3c71665ead825368a3bdaebb711e95d1e1622b3113b0797"
    sha256 cellar: :any_skip_relocation, sonoma:        "1db40750e9579e6dc60acc4b35b9c3765620ac1844ffccf016880e777fcc8f4c"
    sha256 cellar: :any_skip_relocation, ventura:       "b69b9f2f8a36d2912add3c92f20adce091fd4e0ea2fb0a07ece4caffb130b311"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f5f5c6a2b24964def0dd4a0d115a44ac141d807b3942238c452fdffd3fb7dd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "093a34e1852f51b30a4cbe8bebedec15370d91f8180eeb0a55996c63e97977a6"
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
    generate_completions_from_executable(bin/"xcbeautify", "--generate-completion-script")
  end

  test do
    log = "CompileStoryboard /Users/admin/MyApp/MyApp/Main.storyboard (in target: MyApp)"
    assert_match "[MyApp] Compiling Main.storyboard",
      pipe_output("#{bin}/xcbeautify --disable-colored-output", log).chomp
    assert_match version.to_s,
      shell_output("#{bin}/xcbeautify --version").chomp
  end
end
