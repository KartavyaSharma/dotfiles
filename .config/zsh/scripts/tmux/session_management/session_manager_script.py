import fire
import subprocess


def create():
    # Final session name store
    final_session_name = ""
    try:
        # Confirm if you want to create a new space or choose a scope
        subprocess.run("gum confirm \"Choose scope?\" && echo \"True\"",
                       shell=True, text=True,
                       check=True, stdout=subprocess.PIPE
                       )
        # Get all ongoing courses
        ongoing = subprocess.run("echo \"Choose the scope of this new tmux space\""
                                 "&& cat ongoing_courses.txt | gum filter",
                                 shell=True, check=True,
                                 text=True, stdout=subprocess.PIPE
                                 )
        chosen = ongoing.stdout.strip().split("\n")[1]
        # Ask if you want to add any extensions to the name
        extension = subprocess.run(
            "gum input --placeholder \"Enter extension, if any.\"",
            shell=True, check=True, text=True, stdout=subprocess.PIPE
        )
        extension = "_" + extension.stdout.strip()
        extension = "" if extension == "_" else extension
        # Construct final session name
        final_session_name = chosen + extension
    except Exception:
        # Ask for custom session name
        custom_name = subprocess.run(
            "gum input --placeholder \"Enter custom tmux session name.\"",
            shell=True, check=True, text=True, stdout=subprocess.PIPE
        )
        final_session_name = custom_name.stdout.strip()

    # Create new tmux session with final name
    subprocess.run(f"tmux new-session -d -s \"{final_session_name}\""
                   f"&& tmux switch -t \"{final_session_name}\"",
                   shell=True, check=True, text=True
                   )
    print("Created new tmux session: " + final_session_name)


if __name__ == "__main__":
    fire.Fire(create)
