class Terraforming < Formula
  desc "Export existing AWS resources to Terraform style (tf, tfstate)"
  homepage "https://terraforming.dtan4.net/"
  url "https://github.com/dtan4/terraforming.git",
      tag:      "v0.18.0",
      revision: "67cb9299f283bc16bd70c197f25edc419bee280f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ae14e8533d790a2d2a7e937f0d36c2bac7a62087375b80e27f2dd2f2171981d6"
    sha256 cellar: :any_skip_relocation, big_sur:       "72f190c258f2ab9a73d635ff533f9814219a79a7261dd0d0b4e1b5cb6eddcb8a"
    sha256 cellar: :any_skip_relocation, catalina:      "5b1a20c820982585fdad1e588ab6ac171e8d3f963da62b50a598e3002635331b"
    sha256 cellar: :any_skip_relocation, mojave:        "e4997ba46e6e796833c2f881f68b20cd52006510371ede211d422190a5223454"
    sha256 cellar: :any_skip_relocation, high_sierra:   "59001edf7447dbab2dd760fcec4fc0a77d711ec43e7d95658aa9c663f7baf44d"
    sha256 cellar: :any_skip_relocation, sierra:        "f1d900508e9b2a38a1e417ee9f0faa050c89332cf9eff1a3de83c96eebead164"
    sha256 cellar: :any_skip_relocation, all:           "9fec9a488184066c7ef10f728be33fcc30afe004d9d5bc6dbe7c187a768b8165"
  end

  uses_from_macos "ruby"

  resource "aws-sdk-autoscaling" do
    url "https://rubygems.org/gems/aws-sdk-autoscaling-1.20.0.gem"
    sha256 "85525581b3084d1ce04d468961bdde2397ab340914579bf0515c45a706cd8815"
  end

  resource "aws-sdk-cloudwatch" do
    url "https://rubygems.org/gems/aws-sdk-cloudwatch-1.20.0.gem"
    sha256 "d904807e172a5cf88b1f13f1944a4595fa51a842c10d1a0ac5065fdf874ac6af"
  end

  resource "aws-sdk-dynamodb" do
    url "https://rubygems.org/gems/aws-sdk-dynamodb-1.25.0.gem"
    sha256 "529c3b1b46c997b5db79274747922669ff9f52caefcf3ee40454bf0c3e3424c8"
  end

  resource "aws-sdk-ec2" do
    url "https://rubygems.org/gems/aws-sdk-ec2-1.80.0.gem"
    sha256 "bb73cefdf95ad413ae7b0fe6fcc2ead6e66f8980ed87bd96a1a7c43fb589551e"
  end

  resource "aws-sdk-efs" do
    url "https://rubygems.org/gems/aws-sdk-efs-1.13.0.gem"
    sha256 "c322bd04fed83efa1d5a4b276cab788b39258c4ecab362a789cc16cc61be05e4"
  end

  resource "aws-sdk-elasticache" do
    url "https://rubygems.org/gems/aws-sdk-elasticache-1.14.0.gem"
    sha256 "a78ae9d6c927f6b5c2b9af40c5bc03453b39d9693dcb05df2730293a52186844"
  end

  resource "aws-sdk-elasticloadbalancing" do
    url "https://rubygems.org/gems/aws-sdk-elasticloadbalancing-1.12.0.gem"
    sha256 "39c04663c91b1a467dd5d9b541d4792be4e5b9e25ee2ffb52e473aeb97d44301"
  end

  resource "aws-sdk-elasticloadbalancingv2" do
    url "https://rubygems.org/gems/aws-sdk-elasticloadbalancingv2-1.26.0.gem"
    sha256 "1dc95fc21b1b1ffeb15801084affc5d915d3c386f6f052f55c760a773424dd6d"
  end

  resource "aws-sdk-iam" do
    url "https://rubygems.org/gems/aws-sdk-iam-1.18.0.gem"
    sha256 "0efba7b586c81d7b17cb3086bf5cb287e68db5487d344877a444c107ee3b2130"
  end

  resource "aws-sdk-kms" do
    url "https://rubygems.org/gems/aws-sdk-kms-1.17.0.gem"
    sha256 "f6e6500300ede3e31edaf14aea9ad05a60aba4402c11946fe147f9d03abc584e"
  end

  resource "aws-sdk-rds" do
    url "https://rubygems.org/gems/aws-sdk-rds-1.50.0.gem"
    sha256 "f62b6f0c87cf358a59b440a40ebbb79d6be6eeb5c2f4e5f159fc8ee3d1cf7a1b"
  end

  resource "aws-sdk-redshift" do
    url "https://rubygems.org/gems/aws-sdk-redshift-1.23.0.gem"
    sha256 "99ecbd9f050e4dd80c80f1119a273c75abdb5a5abf02b37c61f39234ee762678"
  end

  resource "aws-sdk-route53" do
    url "https://rubygems.org/gems/aws-sdk-route53-1.22.0.gem"
    sha256 "1b7aaabc67e4133a34c07c5fa979b00374866026d3f3bd130b992fa163f6b211"
  end

  resource "aws-sdk-s3" do
    url "https://rubygems.org/gems/aws-sdk-s3-1.36.1.gem"
    sha256 "b5baf7c91119791354a14424ef7af8917b6806a2b33878bf80f22b256104d0bd"
  end

  resource "aws-sdk-sns" do
    url "https://rubygems.org/gems/aws-sdk-sns-1.12.0.gem"
    sha256 "ac98e9dd72a8ecfe18f0e6482c02563050f0638f179725872bd414791a856138"
  end

  resource "aws-sdk-sqs" do
    url "https://rubygems.org/gems/aws-sdk-sqs-1.13.0.gem"
    sha256 "a0bb59cefb6a3a152192303236d0e3a0c0dabd27b7ab6ac3c6993b69598df5b2"
  end

  resource "multi_json" do
    url "https://rubygems.org/gems/multi_json-1.12.2.gem"
    sha256 "5dcc0b569969f3d1658c68b5d597fcdc1fc3a34d4ae92b4615c740d95aaa51e5"
  end

  resource "thor" do
    url "https://rubygems.org/gems/thor-0.20.3.gem"
    sha256 "49bc217fe28f6af34c6e60b003e3405c27595a55689077d82e9e61d4d3b519fa"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--no-document",
             "--install-dir", libexec
    end
    system "gem", "build", "terraforming.gemspec"
    system "gem", "install", "--ignore-dependencies",
           "terraforming-#{version}.gem"
    bin.install libexec/"bin/terraforming"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    output = shell_output("#{bin}/terraforming help ec2")
    assert_match "Usage:", output
    assert_match "terraforming ec2", output
  end
end
