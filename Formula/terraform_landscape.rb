class TerraformLandscape < Formula
  desc "Improve Terraform's plan output"
  homepage "https://github.com/coinbase/terraform-landscape"
  url "https://github.com/coinbase/terraform-landscape/archive/v0.1.18.tar.gz"
  sha256 "49670fd71a115c3f12ae5b9c84f9bf1e0f47734a4501ad3cc1ea980068066de7"

  bottle do
    cellar :any_skip_relocation
    sha256 "1359014f1c085eab4504073128620a0f7d15110e5bd486237102a8625795ec8d" => :high_sierra
    sha256 "7591a60f166b102d15c8498e84215f09f3977bd4bfbd0b6142bf3f1af547fad0" => :sierra
    sha256 "b505ec407bdca7dfd380007edc3f97216401a400ff4510cc8033e978f2aae642" => :el_capitan
  end

  depends_on "ruby" if MacOS.version <= :mountain_lion

  resource "colorize" do
    url "https://rubygems.org/gems/colorize-0.8.1.gem"
    sha256 "0ba0c2a58232f9b706dc30621ea6aa6468eeea120eb6f1ccc400105b90c4798c"
  end

  resource "commander" do
    url "https://rubygems.org/gems/commander-4.4.5.gem"
    sha256 "d6ee57931e589e89c5ed27b2fdb1661ba28c6c021c635bbac6e96ded55363e6b"
  end

  resource "diffy" do
    url "https://rubygems.org/gems/diffy-3.2.1.gem"
    sha256 "4ffe1a7b01c958053407f9a8e6492c3e8c11b59db0ab5c3ae44f056067ae3185"
  end

  resource "highline" do
    url "https://rubygems.org/gems/highline-1.7.10.gem"
    sha256 "1e147d5d20f1ad5b0e23357070d1e6d0904ae9f71c3c49e0234cf682ae3c2b06"
  end

  resource "polyglot" do
    url "https://rubygems.org/gems/polyglot-0.3.5.gem"
    sha256 "59d66ef5e3c166431c39cb8b7c1d02af419051352f27912f6a43981b3def16af"
  end

  resource "treetop" do
    url "https://rubygems.org/gems/treetop-1.6.10.gem"
    sha256 "67df9f52c5fdeb7b2b8ce42156f9d019c1c4eb643481a68149ff6c0b65bc613c"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.verify_download_integrity(r.fetch)
      system "gem", "install", r.cached_download, "--no-document",
                    "--install-dir", libexec
    end
    system "gem", "build", "terraform_landscape.gemspec"
    system "gem", "install", "--ignore-dependencies", "terraform_landscape-#{version}.gem"
    bin.install libexec/"bin/landscape"
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])
  end

  test do
    output = shell_output("#{bin}/landscape -v")
    assert_match "Terraform Landscape #{version}", output

    test_input = "+ some_resource_type.some_resource_name"
    colorized_expected_output = "\e[0;32;49m+ some_resource_type.some_resource_name\e[0m\n\n\n"

    output = shell_output("echo '#{test_input}' | #{bin}/landscape")
    assert_match colorized_expected_output, output
  end
end
