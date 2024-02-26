class Sponge < Formula
  desc "Soak up standard input and write to a file"
  homepage "https://joeyh.name/code/moreutils/"
  url "https://git.joeyh.name/index.cgi/moreutils.git/snapshot/moreutils-0.68.tar.gz"
  sha256 "5eb14bc7bc1407743478ebdbd83772bf3b927fd949136a2fbbde96fa6000b6e7"
  license "GPL-2.0-only"
  head "https://git.joeyh.name/git/moreutils.git", branch: "master"

  livecheck do
    formula "moreutils"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bdf1dc52190685472fa4d0686af41655a87ed7579161b182fb58ca082ad91198"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14bde30ead12b90d9454f457efde825227aa8ef6bab17764462733cdc1a14ba7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3501079babb29c37bb68dc3ff246cc143cff026363622eb7f94178fb882de17"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1cc845291f37d3fb96c9eb53cf6563af529b26aa1e93f3c87dad8204f1d9fce"
    sha256 cellar: :any_skip_relocation, ventura:        "915bd9caeb08517c25875628af7b97d7f039d7a1c5a1bc3e0e2d7c88b01b9318"
    sha256 cellar: :any_skip_relocation, monterey:       "de50c8b42e53ff53750ebff6599545248f9bac0fce1350529bc8c2ebdd6abe84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cba54480344af4958f0d4c501914de841b0144286d6120f25d7c1d6d6fb07c7"
  end

  conflicts_with "moreutils", because: "both install a `sponge` executable"

  def install
    system "make", "sponge"
    bin.install "sponge"
  end

  test do
    file = testpath/"sponge-test.txt"
    file.write("c\nb\na\n")
    system "sort #{file} | #{bin/"sponge"} #{file}"
    assert_equal "a\nb\nc\n", File.read(file)
  end
end
