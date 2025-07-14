class Spacer < Formula
  desc "Small command-line utility for adding spacers to command output"
  homepage "https://github.com/samwho/spacer"
  url "https://github.com/samwho/spacer/archive/refs/tags/v0.3.9.tar.gz"
  sha256 "5bbb11699b59f81f74236e1b68ae090dbce5344cda9e386c117747f87d12dd78"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f9dace2501bdfe433a11173f816898310a005ec63888827fb15866792d188e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70b178e65ccd32753ab22859b9a25d965b954e90104ae65a38a1794acaac131f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38577cf8851f5975d5d7d91896128c47c6fb9498d7886fdfabd7dfae63f88798"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4f664ad17ce98093fdefe6464a590982f6e5b1adfce2d05a4b0f65bda8b9808"
    sha256 cellar: :any_skip_relocation, ventura:       "2d325b69609ebe1d06fd8e508d2df50497b8af3119efe9928697661c887fa518"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a689fb76c74d4a6c8f04f69b6beb599e7216bb998e9d88f916f0ebe0a34d36ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06c0f5a4eb4b8ba31609c37ff87c3e089c4524dbd5cb718c475b461994cae6b5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spacer --version").chomp
    date = shell_output("date +'%Y-%m-%d'").chomp
    spacer_in = shell_output(
      "i=0
      while [ $i -le 2 ];
        do echo $i; sleep 1
        i=$(( i + 1 ))
      done | #{bin}/spacer --after 0.5",
    ).chomp
    assert_includes spacer_in, date
  end
end
