require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-8.3.21.tgz"
  sha256 "7d6c7ff55042d8911043085dd45c83339bfb1bd28db0e2e452da74a517ba356d"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f2d9314c9886aeba258bf3059994e8f05c970d0665f86e69c4614dec46f8674" => :catalina
    sha256 "58c2d26ad2c7149a7b5191c6a9318bdf0d7e376d72beb6c4c9cbc61a3315131a" => :mojave
    sha256 "88d06f691920c79f5c7910d8f536b2bc5512f949e1819eacf45944e2bca4e5d6" => :high_sierra
    sha256 "35ef93f49ccd4308de30640c44b2bb315bb5d0ceb153aac17ecd83d114e777b6" => :x86_64_linux
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
