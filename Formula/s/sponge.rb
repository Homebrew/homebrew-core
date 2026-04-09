class Sponge < Formula
  desc "Soak up standard input and write to a file"
  homepage "https://joeyh.name/code/moreutils/"
  url "https://git.joeyh.name/index.cgi/moreutils.git/snapshot/moreutils-0.70.tar.gz"
  sha256 "f2bf46d410ba567cc8d01507e94916994e48742722e690dc498fab59f5250132"
  license "GPL-2.0-only"
  head "https://git.joeyh.name/git/moreutils.git", branch: "master"

  livecheck do
    formula "moreutils"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71b1f42aa7b050750fe4887dd349ac22ec8050fd092b2d491dcedd73725cee90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "695617b8c9e56e08a5bda5a83859bd8b15db0075eaad8f9f94f980d9cbdfddbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32624015555fbcfe609e8bf7d203c43413dcf0d8568c27d3cbbc8612c40df98d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f4e10bb9eea15e17aa64b895b04fa9422091065ba67588d5f915a718d59f8e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3725ce0dca9b5bc8666199d9a44b142be0eda23b9f9f66086f06298e24a36da"
    sha256 cellar: :any_skip_relocation, ventura:       "49f2c6da0632f13e6dc655fe1ec9f1c261f2fafb5f0f692bc27e79c43658b9ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a3387e07bc7db6d8e0aea84ddc12a7870c42bd5b47ac404079f94341e2332e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12987019e4ea708b67334ec946a8cc5e7e052e87db10107cd7bbea862268dcbf"
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
