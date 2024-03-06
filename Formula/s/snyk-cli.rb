require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1283.0.tgz"
  sha256 "0e071c18fa785c88b7f8fe961fc85968ab7cb16d5ca73982f15e115960391eda"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a4c4e732441c835d18458595a49f066a2e235683758a4d1414261a611231808"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc01616bc2514ff5040cc8e560b37dcbb936e85db4ac330cf123e5d5fcc1028f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b906389ede11395d6783b635bf4c862d3f5799a61234237ebce8d6b6807c568e"
    sha256 cellar: :any_skip_relocation, sonoma:         "674a3bc7ea8165f2633016682ef8cefed703a7c210753c4736227b0b67da9121"
    sha256 cellar: :any_skip_relocation, ventura:        "2701cc9ca7300197a58e3563e578dc762c383cf142df56764404812feeccccc6"
    sha256 cellar: :any_skip_relocation, monterey:       "fda04e69934b70b1985cc1537a250dfee13ffb1c9530f207646c5ecd87223467"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4de4d7db21d98eafd64b260c99fc296337eabf08a61910f2db7218da73f4df12"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "Authentication failed. Please check the API token on https://snyk.io", output
  end
end
