class Tmuxinator < Formula
  desc "Manage complex tmux sessions easily"
  homepage "https://github.com/tmuxinator/tmuxinator"
  url "https://github.com/tmuxinator/tmuxinator/archive/v1.1.3.tar.gz"
  sha256 "84fdc5fff0d76e415cfd165e79cb21682f9dc68e58a771dbe968099956609568"
  head "https://github.com/tmuxinator/tmuxinator.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb4389494ccfc00cc1d8d8cf715992a6ba840caf3514585d93746a28bc93fa85" => :catalina
    sha256 "7d575e145d4894e8cb3811aa26186a8a9038556ce7e8588c24abcab400bdcdff" => :mojave
    sha256 "2b8723d4a35e4a70d6de828b29a5652677e57ef4ec359c545b5d9e5f2976d8a7" => :high_sierra
    sha256 "ee4743178885ca35c0d32ac7127d4aaf5c3cd08023b2b07af9583558ba31c9bc" => :x86_64_linux
  end

  depends_on "ruby"
  depends_on "tmux"

  resource "erubis" do
    url "https://rubygems.org/downloads/erubis-2.7.0.gem"
    sha256 "63653f5174a7997f6f1d6f465fbe1494dcc4bdab1fb8e635f6216989fb1148ba"
  end

  resource "thor" do
    url "https://rubygems.org/downloads/thor-0.20.3.gem"
    sha256 "49bc217fe28f6af34c6e60b003e3405c27595a55689077d82e9e61d4d3b519fa"
  end

  resource "xdg" do
    url "https://rubygems.org/downloads/xdg-2.2.5.gem"
    sha256 "f3a5f799363852695e457bb7379ac6c4e3e8cb3a51ce6b449ab47fbb1523b913"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end

    system "gem", "build", "tmuxinator.gemspec"
    system "gem", "install", "--ignore-dependencies", "tmuxinator-#{version}.gem"
    bin.install libexec/"bin/tmuxinator"
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])

    bash_completion.install "completion/tmuxinator.bash" => "tmuxinator"
    zsh_completion.install "completion/tmuxinator.zsh" => "_tmuxinator"
    fish_completion.install Dir["completion/*.fish"]
  end

  test do
    version_output = shell_output("#{bin}/tmuxinator version")
    assert_match "tmuxinator #{version}", version_output

    if OS.mac?
      cmd = "source #{bash_completion}/tmuxinator && complete -p tmuxinator"
    else
      cmd = "bash -c \"source #{bash_completion}/tmuxinator && complete -p tmuxinator\""
    end

    completion = shell_output(cmd)
    assert_match "-F _tmuxinator", completion

    commands = shell_output("#{bin}/tmuxinator commands")
    commands_list = %w[
      commands completions new edit open start
      stop local debug copy delete implode
      version doctor list
    ]

    expected_commands = commands_list.join("\n")
    assert_match expected_commands, commands

    list_output = shell_output("#{bin}/tmuxinator list")
    assert_match "tmuxinator projects:", list_output

    system "#{bin}/tmuxinator", "new", "test"
    list_output = shell_output("#{bin}/tmuxinator list")
    assert_equal "tmuxinator projects:\ntest\n", list_output
  end
end
