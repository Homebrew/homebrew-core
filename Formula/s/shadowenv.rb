class Shadowenv < Formula
  desc "Reversible directory-local environment variable manipulations"
  homepage "https://shopify.github.io/shadowenv/"
  url "https://github.com/Shopify/shadowenv/archive/refs/tags/3.4.0.tar.gz"
  sha256 "86313a5022a8e897ceb52a51479fa7a921e44cd520cf04d111ba711684791e44"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ce2a7c3bad03bb0798f59c7782b7fa6fe6c38f5d991dfb9d907f773a69c961a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d2aeaff45d8dd8a42113407ce00768bd7925e0214cdac6562c1a1f1e5af1616"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c96fa5cb66fc2db8280097794a11ef34351bba72ad5284b552493879ff6356aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae5065cfb3bb80e396751f4f0903ab6fbea194f2d0eee8dcd1a557bd52b7faec"
    sha256 cellar: :any_skip_relocation, sonoma:        "19445eb6965c036e799b4e1a0e399cd91068ea9a3a85855f7c35ab219f4a3f15"
    sha256 cellar: :any_skip_relocation, ventura:       "bfa5569c762df9706807c63795c6e6910beb8cbf84dd08df97755355346ee6ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52b23d1a232c2a1cf69554ea10cb6081430df4d13b7e28b64dd99ba0d306cb49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec2f689ad3587af4989c921782c112a7f222816d4b6e258c4f72232c0479b54a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "#{buildpath}/man/man1/shadowenv.1"
    man5.install "#{buildpath}/man/man5/shadowlisp.5"
  end

  test do
    expected_output = <<~EOM
      EXAMPLE:
      EXAMPLE2:b
      EXAMPLE3:b
      EXAMPLE_PATH:a:b:d
      ---
      EXAMPLE:a
      EXAMPLE2:
      EXAMPLE3:a
      EXAMPLE_PATH:c:d
    EOM
    environment = "export EXAMPLE2=b EXAMPLE3=b EXAMPLE_PATH=a:b:d;"
    hash = "1256a7c3de15e864"
    data = {
      "scalars" => [
        { "name" => "EXAMPLE2", "original" => nil, "current" => "b" },
        { "name" => "EXAMPLE", "original" => "a", "current" => nil },
        { "name" => "EXAMPLE3", "original" => "a", "current" => "b" },
      ],
      "lists"   => [
        { "name" => "EXAMPLE_PATH", "additions" => ["b", "a"], "deletions" => ["c"] },
      ],
    }
    # Read ...'\"'\"'... on the next line as a ruby `...' + "'" + '...` but for bash
    shadowenv_cmd = "export __shadowenv_data='\"'\"'#{hash}:#{data.to_json}'\"'\"'; #{bin}/shadowenv hook"
    print_vars =
      "echo EXAMPLE:$EXAMPLE; echo EXAMPLE2:$EXAMPLE2; echo EXAMPLE3:$EXAMPLE3; echo EXAMPLE_PATH:$EXAMPLE_PATH;"

    assert_equal expected_output,
      shell_output("bash -c '#{environment} #{print_vars} echo ---; eval \"$(#{shadowenv_cmd})\"; #{print_vars}'")
  end
end
