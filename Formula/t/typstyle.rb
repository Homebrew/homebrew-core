class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https://enter-tainer.github.io/typstyle/"
  url "https://github.com/Enter-tainer/typstyle/archive/refs/tags/v0.11.26.tar.gz"
  sha256 "1cacda13989b81120fdbb56d016c53d3cb2c30748397bfad948816e852640e36"
  license "Apache-2.0"
  head "https://github.com/Enter-tainer/typstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d577200a5a072e127c54c972e390b61a9cf0aeb5818494fba8a44c8a123cf3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83795299830af5d4ddbcb515309078fdb0b5a10ac8ec79a6d1a9ae286b8623f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfbd92d867045b06af8f4f1f81460ce99abe23a232e6883bd773d910ec65aed4"
    sha256 cellar: :any_skip_relocation, sonoma:         "d934d76561bef11862b26db0b00d3190fd61e26e8b477e4735b7837640540171"
    sha256 cellar: :any_skip_relocation, ventura:        "8b1bc18f4b4709f45aec0e7feda64c33baf25408edff324ef52e762837ea194e"
    sha256 cellar: :any_skip_relocation, monterey:       "85cd7502452fb595edfcace061bb02cb22a450fd5d86159037e35ebc6ac43f21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c51af0747a40aec704109f320e0e0b4cedf1fb71f0ac476c4a0f92202b9ec46"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"Hello.typ").write("Hello World!")
    system bin/"typstyle", "Hello.typ"

    assert_match version.to_s, shell_output("#{bin}/typstyle --version")
  end
end
