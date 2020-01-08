require "language/go"

class TerraformProvisionerAnsible < Formula
  desc "Ansible provisioner for Terraform"
  homepage "https://github.com/jonmorehouse/terraform-provisioner-ansible"
  url "https://github.com/jonmorehouse/terraform-provisioner-ansible/archive/0.0.2.tar.gz"
  sha256 "5ba93ea5d6f28e156d7e4eba90cd89032f7dc6aff396a8429c903da4efa2d8b6"
  head "https://github.com/jonmorehouse/terraform-provisioner-ansible.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "664cff934260d219317c5b875a34d7d9e223f7b0ad3d979943a9d33c7bc6928e" => :catalina
    sha256 "47e33e69955c8da7284077ca6ff8b412433a73955f0df91d477ead370e3b99cd" => :mojave
    sha256 "9c5773e4d576ae2f7e28438587b42170a33a6767c13805ed7ef372ad102bc139" => :high_sierra
    sha256 "a56474f71703f7d660a17ed6faf039e98ccf50d32ce82b2c92fcc907f012ad78" => :sierra
    sha256 "2b96de2a84016f1637fd428d40fcdcf16c960e795ce9307c2fb58672be2d21c0" => :el_capitan
    sha256 "2b9f182b17571e29b4b6767db5974e39d3b5e2e5e1bb87b83b6cf1f28f855a10" => :yosemite
  end

  depends_on "go" => :build
  depends_on "terraform"

  go_resource "github.com/hashicorp/terraform" do
    url "https://github.com/hashicorp/terraform.git",
        :revision => "fa6a83ebdc323f2b415779786e102e69ddbf9a48"
  end

  go_resource "github.com/mitchellh/mapstructure" do
    url "https://github.com/mitchellh/mapstructure.git",
        :revision => "f3009df150dadf309fdee4a54ed65c124afad715"
  end

  go_resource "github.com/mitchellh/go-homedir" do
    url "https://github.com/mitchellh/go-homedir.git",
        :revision => "756f7b183b7ab78acdbbee5c7f392838ed459dda"
  end

  go_resource "github.com/mitchellh/go-linereader" do
    url "https://github.com/mitchellh/go-linereader.git",
        :revision => "07bab5fdd9580500aea6ada0e09df4aa28e68abd"
  end

  def install
    ENV["GOPATH"] = buildpath

    terrapath = buildpath/"src/github.com/jonmorehouse/terraform-provisioner-ansible"
    terrapath.install Dir["*"]

    Language::Go.stage_deps resources, buildpath/"src"

    cd terrapath do
      system "go", "build"
      bin.install "terraform-provisioner-ansible"
      prefix.install_metafiles
    end
  end

  def caveats
    <<~EOS
      Once installed a $HOME/.terraformrc file is used to enable the plugin:

      provisioners {
        ansible = "#{HOMEBREW_PREFIX}/bin/terraform-provisioner-ansible"
      }
    EOS
  end

  test do
    assert_match(/This binary is a plugin/, shell_output("#{bin}/terraform-provisioner-ansible 2>&1", 1))
  end
end
