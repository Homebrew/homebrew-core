class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.9.15.tar.gz"
  sha256 "05a52416c0aeeb8780d56ba0672473f484625133caa29260b66158392af338f2"
  license "Apache-2.0"
  head "https://github.com/containous/yaegi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3438fbc61831b84d3700dbe2f53b71b05a6b3a472a259c67f846ce5989e0f9a0"
    sha256 cellar: :any_skip_relocation, big_sur:       "44829f67f2a1ba725769a98ab35ae16676b7e3bd4c0540bc8cce80ff59e356e3"
    sha256 cellar: :any_skip_relocation, catalina:      "aa935e2fe6bf84cab1220d797a585ac31f6ffe269bb9563faa0cdc563ac5a666"
    sha256 cellar: :any_skip_relocation, mojave:        "6fd121dac1fbbc46404a9b7cb5a726da8e866ac7c90c2340e9551f5574fac03a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
