class RipgrepAll < Formula
  desc "Wrapper around ripgrep that adds multiple rich file types"
  homepage "https://github.com/phiresky/ripgrep-all"
  url "https://github.com/phiresky/ripgrep-all/archive/refs/tags/v0.10.9.tar.gz"
  sha256 "a5b3150940dcddd35a26e9de398f11a563d0466a335e5450ceb7ff369e9fef45"
  license "AGPL-3.0-or-later"
  head "https://github.com/phiresky/ripgrep-all.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a1935b715dabb6d04c7650f07092ed20883a28d3230c82a189eaf4be8e6ca46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b5ecb4c9267c51f42fb2917f6531bdfeb178ad790e7ef2674b968a40d2944a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30359e9de5c05c815de5df2ac83cc35fbaad2ecbdbe7494f59cc58f204e098c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5d4ca5f5398c6f3bfb53a77bb71aeed0545e50da5bca533f22786d350404fed"
    sha256 cellar: :any_skip_relocation, ventura:       "5071868007570a23d9fdd76e6a48f27cce497b5180d49d9ba3f0ff926d39ac71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcecce222556591cdb97455f0cc481591db30b115aa9d8725e971ce598b50b81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33d24a8354f0cf5c79af8490ed2436537437f20c321c4f1b88e1b6c6f30430d6"
  end

  depends_on "rust" => :build
  depends_on "ripgrep"

  uses_from_macos "zip" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"file.txt").write("Hello World")
    system "zip", "archive.zip", "file.txt"

    output = shell_output("#{bin}/rga 'Hello World' #{testpath}")
    assert_match "Hello World", output
  end
end
