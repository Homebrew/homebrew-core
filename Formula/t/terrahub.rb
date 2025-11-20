class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://web.archive.org/web/20240302100339/https://docs.terrahub.io/"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.5.9.tgz"
  sha256 "0288f47ab305550d0f21633a9a487e1de688556229242bf0c86e120d1240e1c4"
  license "MPL-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "f55d63174552fd453e84e74afdb9c3d7d76cf070ee8171f84f2a509ae1fb3e39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "338bea3d5cf73bd46b3c98463c61454328de8bd281762ee4e504408e851622c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1c3889a86c9e36878ef3e3e9695c1033e06ba5843c58a9dc852684f0ee9911b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1c3889a86c9e36878ef3e3e9695c1033e06ba5843c58a9dc852684f0ee9911b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1c3889a86c9e36878ef3e3e9695c1033e06ba5843c58a9dc852684f0ee9911b"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf9b067ad0af2c0b17f573103306810203382430682d497201701f944d4394b8"
    sha256 cellar: :any_skip_relocation, ventura:        "bf9b067ad0af2c0b17f573103306810203382430682d497201701f944d4394b8"
    sha256 cellar: :any_skip_relocation, monterey:       "bf9b067ad0af2c0b17f573103306810203382430682d497201701f944d4394b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d910829fdd680a735d1683dd502ec0f52720d2b340c9ad435d69ec7f6acf5e22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4916e5335be420a247d7aa5785bb29ac1e17d3bd55015e3cb8d75e726b73d656"
  end

  deprecate! date: "2025-02-13", because: :unmaintained

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".terrahub.yml").write <<~YAML
      project:
        name: terrahub-demo
        code: abcd1234
      vpc_component:
        name: vpc
        root: ./vpc
      subnet_component:
        name: subnet
        root: ./subnet
    YAML
    output = shell_output("#{bin}/terrahub graph")
    assert_match "Project: terrahub-demo", output
  end
end
