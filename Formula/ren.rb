class Ren < Formula
  desc "Rename multiple files in a directory"
  homepage "https://pdb.finkproject.org/pdb/package.php/ren"
  url "https://www.ibiblio.org/pub/Linux/utils/file/ren-1.0.tar.gz"
  sha256 "6ccf51b473f07b2f463430015f2e956b63b1d9e1d8493a51f4ebd70f8a8136c9"
  license :public_domain

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9277aaf4732d7c2ab0b9590bf81a1dfe82a1e8e40dd4d5c2e4369d839bd781c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6b10a80274e2cd7b78b8bbf90e8132511c321ec104bd9418b89814fa6dd2a4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ac0c757ec1ce881161a4f5cf29377fc60070b97a5578802e35edf4d271ee60d"
    sha256 cellar: :any_skip_relocation, ventura:        "985da9224010992dd43987ae41b0a216ea37233d726918aab196326513f1c3a8"
    sha256 cellar: :any_skip_relocation, monterey:       "4c6fb1c77c59fd33c98809ae637e443959d671ad4ae66a5b03ee384714f8521f"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b693ca6331acfcd0df015f3dd19c57ac97aed62f02013f3df2cc62d72387533"
    sha256 cellar: :any_skip_relocation, catalina:       "29c6fe9c0e66e571fd15e9593e94d4a27feb3dd4bb5f0091e8fc6d5dc32d3727"
    sha256 cellar: :any_skip_relocation, mojave:         "dd045987a704bd9690e5466337f7a55105c25c98807e430c74ad4b8702f4b292"
    sha256 cellar: :any_skip_relocation, high_sierra:    "7cf1fe07fb7a4cd0e6171f65a8fda8187973c879b8853e416c39282527f1c0ef"
    sha256 cellar: :any_skip_relocation, sierra:         "bf3e11211d6884d8969fc99ccf8a42b3132dc48bd3100492a442eb5a41fdbd88"
    sha256 cellar: :any_skip_relocation, el_capitan:     "966876dfcc9f36c4bc3d1358a9a8500c79d9324ebd8697033571146f1e482685"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "355528c07f8022b72a8f20419d97004040f5348e60596f84ab9f3ab461cbb13f"
  end

  def install
    system "make"
    bin.install "ren"
    man1.install "ren.1"
  end

  test do
    touch "test1.foo"
    touch "test2.foo"
    system bin/"ren", "*.foo", "#1.bar"
    assert_predicate testpath/"test1.bar", :exist?
    assert_predicate testpath/"test2.bar", :exist?
    refute_predicate testpath/"test1.foo", :exist?
    refute_predicate testpath/"test2.foo", :exist?
  end
end
