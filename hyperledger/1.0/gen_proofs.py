from __future__ import print_function
import json
import os

with open('chicken_poll_proofs.json') as data_file:
    proofs = json.load(data_file)

    if not os.path.exists("./proofs/"):
        os.makedirs("./proofs/")

################# Election Initiation #################
    f = open("./proofs/election_public.log.txt","w")
    f.write(str(proofs['election_public']))
    f.close()

    f = open("./proofs/zeus_public.log.txt","w")
    f.write(str(proofs['zeus_public']))
    f.close()

    f = open("./proofs/cryptosystem.log.txt","w")
    f.write(str(proofs['cryptosystem']))
    f.close()

    f = open("./proofs/election_fingerprint.log.txt","w")
    f.write(str(proofs['election_fingerprint']))
    f.close()

    f = open("./proofs/zeus_key_proof.log.txt","w")
    f.write(str(proofs['zeus_key_proof']))
    f.close()

    f = open("./proofs/trustees.log.txt","w")
    trustees = proofs['trustees']
    for trustee, info in trustees.items():
        f.write(trustee+":")
        f.write(str(info)+"\n")
    f.close()

    f = open("./proofs/candidates.log.txt","w")
    f.write(str(proofs['candidates']))
    f.close()

    f = open("./proofs/election_report.log.txt","w")
    f.write(str(proofs['election_report']))
    f.close()

    f = open("./proofs/zeus_key_proof.log.txt","w")
    f.write(str(proofs['zeus_key_proof']))
    f.close()

    f = open("./proofs/voters.log.txt","w")
    voters = proofs['voters']
    for voter, info in voters.items():
        f.write(voter+":")
        f.write(str(info)+"\n")
    f.close()

    f = open("./proofs/voter_audit_codes.log.txt","w")
    voter_audit_codes = proofs['voter_audit_codes']
    for voter_audit_code, info in voter_audit_codes.items():
        f.write(voter_audit_code+":")
        f.write(str(info)+"\n")
    f.close()

################# Voting Phase #################

    f = open("./proofs/votes.log.txt","w")
    votes = proofs['votes']
    for vote in votes:
        f.write((str(vote)+"\n").replace("\\n", "##"))
    f.close()

    f = open("./proofs/audit_requests.log.txt","w")
    f.write(str(proofs['audit_requests']))
    f.close()

    f = open("./proofs/audit_publications.log.txt","w")
    f.write(str(proofs['audit_publications']))
    f.close()

    f = open("./proofs/cast_votes.log.txt","w")
    cast_votes = proofs['cast_votes']
    for cast_vote, info in cast_votes.items():
        f.write(cast_vote+":")
        f.write(str(info)+"\n")
    f.close()

    f = open("./proofs/excluded_voters.log.txt","w")
    f.write(str(proofs['excluded_voters']))
    f.close()

################# Mixing Phase #################

    f = open("./proofs/mixes.log.txt","w")
    f.write(str(proofs['mixes']))
    f.close()

    f = open("./proofs/trustee_factors.log.txt","w")
    f.write(str(proofs['trustee_factors']))
    f.close()

################### Results ####################

    f = open("./proofs/zeus_decryption_factors.log.txt","w")
    f.write(str(proofs['zeus_decryption_factors']))
    f.close()

    f = open("./proofs/cast_vote_index.log.txt","w")
    f.write(str(proofs['cast_vote_index']))
    f.close()

    f = open("./proofs/results.log.txt","w")
    f.write(str(proofs['results']))
    f.close()
