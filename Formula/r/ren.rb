class Ren < Formula
  desc "Rename multiple files in a directory"
  homepage "https://pdb.finkproject.org/pdb/package.php/ren"
  url "https://www.ibiblio.org/pub/Linux/utils/file/ren-1.0.tar.gz"
  sha256 "6ccf51b473f07b2f463430015f2e956b63b1d9e1d8493a51f4ebd70f8a8136c9"
  license :public_domain

  livecheck do
    skip "Not actively developed or maintained"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "9f780992d99547f095b09b50acb32ffe22ac0b9e973965931cbb2ce796ba2d1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7a3c1d2e3849aad71fa4b7f54cfbae86184153159a8019839ac7fb69747cebc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e228ed14477809a0b2e182d476e09213ac70ffa87469e637e3c8d0f446be2a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9277aaf4732d7c2ab0b9590bf81a1dfe82a1e8e40dd4d5c2e4369d839bd781c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6b10a80274e2cd7b78b8bbf90e8132511c321ec104bd9418b89814fa6dd2a4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ac0c757ec1ce881161a4f5cf29377fc60070b97a5578802e35edf4d271ee60d"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d06caa4062b59b1cddb36e26d3e69dada887ed756a53d3da5cf33583851e01e"
    sha256 cellar: :any_skip_relocation, ventura:        "985da9224010992dd43987ae41b0a216ea37233d726918aab196326513f1c3a8"
    sha256 cellar: :any_skip_relocation, monterey:       "4c6fb1c77c59fd33c98809ae637e443959d671ad4ae66a5b03ee384714f8521f"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b693ca6331acfcd0df015f3dd19c57ac97aed62f02013f3df2cc62d72387533"
    sha256 cellar: :any_skip_relocation, catalina:       "29c6fe9c0e66e571fd15e9593e94d4a27feb3dd4bb5f0091e8fc6d5dc32d3727"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "64e739899aad37892c2f55907c142bacc1fe090cf2363aa8256e1d8564e4a845"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "355528c07f8022b72a8f20419d97004040f5348e60596f84ab9f3ab461cbb13f"
  end

  def install
    # Fix compile with newer Clang
    if DevelopmentTools.clang_build_version >= 1403
      ENV.append_to_cflags "-Wno-implicit-int -Wno-implicit-function-declaration"
    end

    system "make"
    bin.install "ren"
    man1.install "ren.1"
  end

  test do
    touch "test1.foo"
    touch "test2.foo"
    system bin/"ren", "*.foo", "#1.bar"
    assert_path_exists testpath/"test1.bar"
    assert_path_exists testpath/"test2.bar"
    refute_path_exists testpath/"test1.foo"
    refute_path_exists testpath/"test2.foo"
  end
end
