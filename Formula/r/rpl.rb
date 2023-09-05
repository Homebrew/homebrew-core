class Rpl < Formula
  include Language::Python::Virtualenv

  desc "Text replacement utility"
  homepage "https://github.com/rrthomas/rpl"
  url "https://files.pythonhosted.org/packages/2c/73/13f76208c9e6312e27bd6d5f62ff867746b7c075b9451448803dc13b2834/rpl-1.15.5.tar.gz"
  sha256 "ae13d2fa1c1b8eaab75ff5756cbea9cc6836b55c4191e332521682be69de1b83"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33bdfb7ac03b2f0bc8fa9744ce91ff3bcab8e95f729b219f2c52796ed3039b5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8260d9b4929478ebb46333397ceaa14b54908f1ad54237eeff07398e76c4c06d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b45f7e45719d16c8181411f29f330251bf20a0e4af946c76653f386307ffefa9"
    sha256 cellar: :any_skip_relocation, ventura:        "bc7e9093f065ce21c4453a4672dbbfe711552cd8307ad3996f7926e68d030c0f"
    sha256 cellar: :any_skip_relocation, monterey:       "87d755ad01e755e32f8d67bfe5a4a005ecfcf8c2117e813e195d4c624ca7732f"
    sha256 cellar: :any_skip_relocation, big_sur:        "416a16df6f81200d1ece3520963a6d77cc82330d91f760566436c76b6a4bf5a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10b3e52f32e8819483105ea0e5b94674e7019b92b02ae8207f4387296fcd7af9"
  end

  depends_on "python@3.11"

  resource "chainstream" do
    url "https://files.pythonhosted.org/packages/44/fd/ec0c4df1e2b00080826b3e2a9df81c912c8dc7dbab757b55d68af3a51dcf/chainstream-1.0.1.tar.gz"
    sha256 "df4d8fd418b112690e0e6faa4cb6706962e4b6b95ff5c133890fd32157c8d3b7"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/41/32/cdc91dcf83849c7385bf8e2a5693d87376536ed000807fa07f5eab33430d/chardet-5.1.0.tar.gz"
    sha256 "0d62712b956bc154f85fb0a266e2a3c5913c2967e00348701b32411d6def31e5"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/77/5d/98efc9cf46d60f3704cf00f8b3bd81319493639fd4367efb5d02fd29ffc1/regex-2023.5.5.tar.gz"
    sha256 "7d76a8a1fc9da08296462a18f16620ba73bcbf5909e42383b253ef34d9d5141e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test").write "I like water."

    system "#{bin}/rpl", "-v", "water", "beer", "test"
    assert_equal "I like beer.", (testpath/"test").read
  end
end
