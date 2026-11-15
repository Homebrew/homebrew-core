class Ripsecrets < Formula
  desc "Prevent committing secret keys into your source code"
  homepage "https://github.com/sirwart/ripsecrets"
  url "https://github.com/sirwart/ripsecrets/archive/refs/tags/v0.1.11.tar.gz"
  sha256 "786c1b7555c1f9562d7eb3994d932445ab869791be65bc77b8bd1fbbae3890b8"
  license "MIT"
  head "https://github.com/sirwart/ripsecrets.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b981eeca803e7136fba0f9fc38cc1b1af270b8b12c7f55e1dc18eeeb41eef0b5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "600344086e56b08665e72f32a3ce9ca0977840fa50270630c2cf349a9b8ae8f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cf5f3f88764cbae3d95c36c959c18cc070e4a557ad93ef5dcd97da9f751d5bfa"
    sha256 cellar: :any,                 arm64_linux:       "174554dc8cd46c5b3228c7133aa2a2cb7e8aeec00bb65a9d41687e810594c264"
    sha256 cellar: :any,                 x86_64_linux:      "f369e23d46bc0ef24e32ab7a3c477933d54daea2d5a5400d02b39ce074dc5311"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    out_dir = Pathname.glob("target/release/**/ripsecrets.bash").first.dirname
    bash_completion.install "#{out_dir}/ripsecrets.bash" => "ripsecrets"
    fish_completion.install "#{out_dir}/ripsecrets.fish"
    zsh_completion.install "#{out_dir}/_ripsecrets"
    man1.install "#{out_dir}/ripsecrets.1"
  end

  test do
    # Generate a real-looking key
    keyspace = "A".upto("Z").to_a + "a".upto("z").to_a + "0".upto("9").to_a + ["_"]
    fake_key = Array.new(36).map { keyspace.sample }
    # but mark it as allowed to test more of the program
    (testpath/"test.txt").write("ghp_#{fake_key.join} # pragma: allowlist secret")

    system bin/"ripsecrets", (testpath/"test.txt")
  end
end
